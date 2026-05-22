import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearLoteRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarLoteRequest.dart';
import 'package:iventi/features/inventory/mappers/LoteMapper.dart';
import 'package:iventi/features/inventory/repositories/ProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/ILoteRepository.dart';

class LoteRepository implements ILoteRepository {
  final PostgresDatasource _datasource;
  final ProductoRepository _productoRepository;

  LoteRepository(this._datasource, this._productoRepository);

  Future<Connection> get _conexion => _datasource.connection;

  Future<LoteEntity> crearLote(CrearLoteRequest request) async {
    final conexion = await _conexion;

    try {
      final loteInsertado = await conexion.execute(
        Sql.named('''
          INSERT INTO lotes (id_producto, fecha_compra, fecha_vencimiento, cantidad_actual,
            cantidad_comprada, cantidad_perdida, precio_compra, creado_en, actualizado_en)
          VALUES (@id_producto, @fecha_compra, @fecha_vencimiento, @cantidad_comprada,
            @cantidad_comprada, @cantidad_perdida, @precio_compra, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
          RETURNING *
        '''),
        parameters: {
          'id_producto': request.idProducto,
          'fecha_compra': request.fechaCompra,
          'fecha_vencimiento': request.fechaVencimiento,
          'cantidad_comprada': request.cantidadComprada,
          'cantidad_perdida': request.cantidadPerdida,
          'precio_compra': request.precioCompra,
        },
      );

      final loteCreado = LoteMapper.fromMap(loteInsertado.first.toColumnMap());

      await _productoRepository.actualizarStockActual(request.idProducto);

      return loteCreado;
    } catch (e) {
      throw DatabaseException('Error al crear lote: $e');
    }
  }

  Future<LoteEntity?> obtenerLotePorId(int idProducto, int idLote) async {
    final conexion = await _conexion;

    try {
      final lotesEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM lotes WHERE id_producto = @id_producto AND id_lote = @id_lote AND es_activo = TRUE'),
        parameters: {'id_producto': idProducto, 'id_lote': idLote},
      );

      if (lotesEncontrados.isEmpty) return null;

      return LoteMapper.fromMap(lotesEncontrados.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al obtener lote: $e');
    }
  }

  Future<List<LoteEntity>> obtenerLotesDeProducto(int idProducto) async {
    final conexion = await _conexion;

    try {
      final lotesEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM lotes WHERE id_producto = @id AND es_activo = TRUE AND cantidad_actual > 0 ORDER BY id_lote ASC'),
        parameters: {'id': idProducto},
      );

      return lotesEncontrados
          .map((fila) => LoteMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener lotes: $e');
    }
  }

  Future<LoteEntity> actualizarLote(ActualizarLoteRequest request) async {
    final conexion = await _conexion;

    try {
      final loteActualizado = await conexion.execute(
        Sql.named('''
          UPDATE lotes
          SET cantidad_actual = @cantidad_actual, cantidad_comprada = @cantidad_comprada,
              cantidad_perdida = @cantidad_perdida, precio_compra = @precio_compra,
              fecha_compra = @fecha_compra, fecha_vencimiento = @fecha_vencimiento,
              actualizado_en = CURRENT_TIMESTAMP
          WHERE id_producto = @id_producto AND id_lote = @id_lote AND es_activo = TRUE
          RETURNING *
        '''),
        parameters: {
          'id_producto': request.idProducto,
          'id_lote': request.idLote,
          'cantidad_actual': request.cantidadActual,
          'cantidad_comprada': request.cantidadComprada,
          'cantidad_perdida': request.cantidadPerdida,
          'precio_compra': request.precioCompra,
          'fecha_compra': request.fechaCompra,
          'fecha_vencimiento': request.fechaVencimiento,
        },
      );

      if (loteActualizado.isEmpty) {
        throw NotFoundException('Lote no encontrado');
      }

      final loteModificado = LoteMapper.fromMap(loteActualizado.first.toColumnMap());

      await _productoRepository.actualizarStockActual(request.idProducto);

      return loteModificado;
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al actualizar lote: $e');
    }
  }

  Future<void> eliminarLote(int idProducto, int idLote) async {
    final conexion = await _conexion;

    try {
      final loteEliminado = await conexion.execute(
        Sql.named('''
          UPDATE lotes
          SET es_activo = FALSE, cantidad_actual = 0, actualizado_en = CURRENT_TIMESTAMP
          WHERE id_producto = @id_producto AND id_lote = @id_lote AND es_activo = TRUE
        '''),
        parameters: {'id_producto': idProducto, 'id_lote': idLote},
      );

      if (loteEliminado.affectedRows == 0) {
        throw NotFoundException('Lote no encontrado');
      }

      await _productoRepository.actualizarStockActual(idProducto);
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al eliminar lote: $e');
    }
  }

  Future<List<LoteEntity>> obtenerLotesPorFechas(DateTime fechaInicio, DateTime fechaFinal) async {
    final conexion = await _conexion;

    try {
      final lotesEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM lotes WHERE fecha_compra BETWEEN @inicio AND @fin AND es_activo = TRUE ORDER BY fecha_compra ASC'),
        parameters: {
          'inicio': fechaInicio,
          'fin': DateTime(fechaFinal.year, fechaFinal.month, fechaFinal.day, 23, 59, 59),
        },
      );

      return lotesEncontrados
          .map((fila) => LoteMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener lotes por fechas: $e');
    }
  }

  Future<List<LoteEntity>> obtenerLotesPorRangoDeFechasYDias(
      DateTime fechaInicio, DateTime fechaFinal, int diasAntesVencimiento) async {
    final conexion = await _conexion;

    try {
      final fechaLimite = fechaFinal.add(Duration(days: diasAntesVencimiento));

      final lotesEncontrados = await conexion.execute(
        Sql.named('''
          SELECT * FROM lotes
          WHERE fecha_compra BETWEEN @inicio AND @fin
            AND fecha_vencimiento <= @limite
            AND es_activo = TRUE
          ORDER BY fecha_compra ASC
        '''),
        parameters: {
          'inicio': fechaInicio,
          'fin': DateTime(fechaFinal.year, fechaFinal.month, fechaFinal.day, 23, 59, 59),
          'limite': fechaLimite,
        },
      );

      return lotesEncontrados
          .map((fila) => LoteMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener lotes por vencimiento: $e');
    }
  }

  Future<List<LoteEntity>> obtenerLotesProximosAVencer(int diasAntesVencimiento) async {
    final conexion = await _conexion;

    try {
      final fechaLimite = DateTime.now().add(Duration(days: diasAntesVencimiento));

      final lotesEncontrados = await conexion.execute(
        Sql.named('''
          SELECT * FROM lotes
          WHERE fecha_vencimiento IS NOT NULL
            AND fecha_vencimiento <= @limite
            AND fecha_vencimiento > CURRENT_TIMESTAMP
            AND es_activo = TRUE
        '''),
        parameters: {'limite': fechaLimite},
      );

      return lotesEncontrados
          .map((fila) => LoteMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al verificar vencimientos: $e');
    }
  }
}
