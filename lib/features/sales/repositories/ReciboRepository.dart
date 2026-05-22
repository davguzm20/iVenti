import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearReciboRequest.dart';
import 'package:iventi/features/sales/mappers/ReciboMapper.dart';
import 'package:iventi/features/sales/repositories/IReciboRepository.dart';

class ReciboRepository implements IReciboRepository {
  final PostgresDatasource _datasource;

  ReciboRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  Future<ReciboEntity> crearReciboConRequest(CrearReciboRequest request) async {
    final conexion = await _conexion;

    try {
      final reciboCreado = await conexion.execute(
        Sql.named('INSERT INTO recibos (id_venta, id_usuario, monto_cancelado, pagado_en, creado_en) VALUES (@id_venta, @id_usuario, @monto, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING *'),
        parameters: {
          'id_venta': request.idVenta,
          'id_usuario': request.idUsuario,
          'monto': request.montoCancelado,
        },
      );

      return ReciboMapper.fromMap(reciboCreado.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al crear recibo: $e');
    }
  }

  Future<ReciboEntity> crearRecibo(int idVenta, int idUsuario, double montoCancelado, DateTime pagadoEn, Connection conexion) async {
    try {
      final reciboCreado = await conexion.execute(
        Sql.named('INSERT INTO recibos (id_venta, id_usuario, monto_cancelado, pagado_en, creado_en) VALUES (@id_venta, @id_usuario, @monto, @pagado_en, CURRENT_TIMESTAMP) RETURNING *'),
        parameters: {
          'id_venta': idVenta,
          'id_usuario': idUsuario,
          'monto': montoCancelado,
          'pagado_en': pagadoEn,
        },
      );

      return ReciboMapper.fromMap(reciboCreado.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al crear recibo: $e');
    }
  }

  Future<List<ReciboEntity>> obtenerRecibosPorVenta(int idVenta) async {
    final conexion = await _conexion;

    try {
      final recibosEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM recibos WHERE id_venta = @id ORDER BY pagado_en'),
        parameters: {'id': idVenta},
      );

      return recibosEncontrados
          .map((fila) => ReciboMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener recibos: $e');
    }
  }
}
