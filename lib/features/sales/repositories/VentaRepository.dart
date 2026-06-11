import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';
import 'package:iventi/features/sales/mappers/VentaMapper.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';
import 'package:iventi/features/inventory/repositories/LoteRepository.dart';
import 'package:iventi/features/inventory/repositories/ProductoRepository.dart';
import 'package:iventi/features/sales/repositories/ReciboRepository.dart';
import 'package:iventi/features/sales/repositories/IVentaRepository.dart';

class VentaRepository implements IVentaRepository {
  final PostgresDatasource _datasource;
  final LoteRepository _loteRepository;
  final ProductoRepository _productoRepository;

  VentaRepository(this._datasource, this._loteRepository, this._productoRepository);

  Future<Connection> get _conexion => _datasource.connection;

  @override
  Future<VentaEntity> crearVenta(CrearVentaRequest request) async {
    final conexion = await _conexion;

    try {
      await conexion.execute('BEGIN');

      final nuevoEstado = request.montoCancelado >= request.montoTotal
          ? EstadoVenta.COMPLETADA.name
          : EstadoVenta.PENDIENTE.name;

      final ventaInsertada = await conexion.execute(
        Sql.named('''
          INSERT INTO ventas (id_cliente, id_usuario, monto_total, monto_cancelado, estado, es_credito, codigo_boleta, creado_en, actualizado_en)
          VALUES (@id_cliente, @id_usuario, @monto_total, @monto_cancelado, @estado, @es_credito, CASE WHEN @monto_total::numeric > 5 THEN generar_codigo_boleta() ELSE NULL END, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
          RETURNING id_venta, vendido_en, creado_en, codigo_boleta
        '''),
        parameters: {
          'id_cliente': request.idCliente,
          'id_usuario': request.idUsuario,
          'monto_total': request.montoTotal,
          'monto_cancelado': request.montoCancelado,
          'estado': nuevoEstado,
          'es_credito': request.esCredito,
        },
      );

      final idVenta = ventaInsertada.first.toColumnMap()['id_venta'] as int;
      final vendidoEn = ventaInsertada.first.toColumnMap()['vendido_en'] as DateTime;
      final creadoEn = ventaInsertada.first.toColumnMap()['creado_en'] as DateTime;
      final codigoBoleta = ventaInsertada.first.toColumnMap()['codigo_boleta'] as String?;

      for (final detalleReq in request.detalles) {
        await conexion.execute(
          Sql.named('''
            INSERT INTO detalle_ventas (id_venta, id_lote, cantidad, precio_unitario, subtotal, descuento, creado_en)
            VALUES (@id_venta, @id_lote, @cantidad, @precio_unitario, @subtotal, @descuento, CURRENT_TIMESTAMP)
          '''),
          parameters: {
            'id_venta': idVenta,
            'id_lote': detalleReq.idLote,
            'cantidad': detalleReq.cantidad,
            'precio_unitario': detalleReq.precioUnitario,
            'subtotal': detalleReq.subtotal,
            'descuento': detalleReq.descuento,
          },
        );

        final loteActual = await _loteRepository.obtenerLotePorId(detalleReq.idProducto, detalleReq.idLote);

        if (loteActual != null) {
          await conexion.execute(
            Sql.named('UPDATE lotes SET cantidad_actual = cantidad_actual - @cantidad, actualizado_en = CURRENT_TIMESTAMP WHERE id_lote = @id_lote'),
            parameters: {'cantidad': detalleReq.cantidad, 'id_lote': detalleReq.idLote},
          );
        }

        await _productoRepository.actualizarStockActual(detalleReq.idProducto);
      }

      if (request.montoCancelado > 0) {
        final reciboRepo = ReciboRepository(_datasource);

        await reciboRepo.crearRecibo(idVenta, request.idUsuario, request.montoCancelado, vendidoEn, conexion);
      }

      await conexion.execute('COMMIT');

      return VentaEntity(
        idVenta: idVenta,
        idCliente: request.idCliente,
        idUsuario: request.idUsuario,
        codigoBoleta: codigoBoleta,
        vendidoEn: vendidoEn,
        montoTotal: request.montoTotal,
        montoCancelado: request.montoCancelado,
        estado: request.montoCancelado >= request.montoTotal ? EstadoVenta.COMPLETADA : EstadoVenta.PENDIENTE,
        esCredito: request.esCredito,
        creadoEn: creadoEn,
      );
    } catch (e) {
      await conexion.execute('ROLLBACK');

      throw DatabaseException('Error al crear venta: $e');
    }
  }

  @override
  Future<VentaEntity?> obtenerVentaPorId(int idVenta) async {
    final conexion = await _conexion;

    try {
      final ventasEncontradas = await conexion.execute(
        Sql.named('SELECT * FROM ventas WHERE id_venta = @id'),
        parameters: {'id': idVenta},
      );

      if (ventasEncontradas.isEmpty) return null;

      return VentaMapper.fromMap(ventasEncontradas.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al obtener venta: $e');
    }
  }

  @override
  Future<List<VentaEntity>> obtenerVentasPorFiltros({
    required int limite,
    required int offset,
    bool? esAlContado,
    DateTime? fechaInicio,
    DateTime? fechaFinal,
  }) async {
    final conexion = await _conexion;

    try {
      final parametros = <String, dynamic>{'limite': limite, 'offset': offset};
      String sql = 'SELECT * FROM ventas WHERE 1=1';

      if (esAlContado == true) {
        sql += ' AND es_credito = FALSE';
      } else if (esAlContado == false) {
        sql += ' AND es_credito = TRUE';
      }

      if (fechaInicio != null && fechaFinal != null) {
        sql += ' AND vendido_en BETWEEN @inicio AND @fin';
        parametros['inicio'] = fechaInicio;
        parametros['fin'] = DateTime(fechaFinal.year, fechaFinal.month, fechaFinal.day, 23, 59, 59);
      } else if (fechaInicio != null) {
        sql += ' AND vendido_en >= @inicio';
        parametros['inicio'] = fechaInicio;
      } else if (fechaFinal != null) {
        sql += ' AND vendido_en <= @fin';
        parametros['fin'] = DateTime(fechaFinal.year, fechaFinal.month, fechaFinal.day, 23, 59, 59);
      }

      sql += ' ORDER BY vendido_en DESC LIMIT @limite OFFSET @offset';

      final ventasEncontradas = await conexion.execute(Sql.named(sql), parameters: parametros);

      return ventasEncontradas
          .map((fila) => VentaMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al filtrar ventas: $e');
    }
  }

  @override
  Future<List<VentaEntity>> obtenerVentasDeCliente(int idCliente, {bool? esAlContado}) async {
    final conexion = await _conexion;

    try {
      String query = 'SELECT * FROM ventas WHERE id_cliente = @id_cliente';
      final params = <String, dynamic>{'id_cliente': idCliente};

      if (esAlContado != null) {
        query += ' AND es_credito = @es_credito';
        params['es_credito'] = esAlContado;
      }
      query += ' ORDER BY vendido_en ASC';

      final ventasEncontradas = await conexion.execute(
        Sql.named(query),
        parameters: params,
      );

      return ventasEncontradas
          .map((fila) => VentaMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener ventas del cliente: $e');
    }
  }

  @override
  Future<List<VentaEntity>> obtenerVentasPorFechas(DateTime fechaInicio, DateTime fechaFinal) async {
    final conexion = await _conexion;

    try {
      final ventasEncontradas = await conexion.execute(
        Sql.named('SELECT * FROM ventas WHERE vendido_en BETWEEN @inicio AND @fin ORDER BY vendido_en DESC'),
        parameters: {
          'inicio': fechaInicio,
          'fin': DateTime(fechaFinal.year, fechaFinal.month, fechaFinal.day, 23, 59, 59),
        },
      );

      return ventasEncontradas
          .map((fila) => VentaMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener ventas por fechas: $e');
    }
  }

  @override
  Future<void> actualizarMontoCanceladoVenta(int idVenta, double montoACancelar) async {
    final conexion = await _conexion;

    try {
      final ventaExistente = await obtenerVentaPorId(idVenta);

      if (ventaExistente == null) {
        throw NotFoundException('Venta no encontrada');
      }

      final nuevoMonto = ventaExistente.montoCancelado + montoACancelar;
      final nuevoEstado = nuevoMonto >= ventaExistente.montoTotal
          ? EstadoVenta.COMPLETADA.name
          : EstadoVenta.PENDIENTE.name;

      await conexion.execute(
        Sql.named('UPDATE ventas SET monto_cancelado = @monto, estado = @estado, actualizado_en = CURRENT_TIMESTAMP WHERE id_venta = @id'),
        parameters: {'monto': nuevoMonto, 'estado': nuevoEstado, 'id': idVenta},
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al actualizar monto cancelado: $e');
    }
  }

  @override
  Future<void> actualizarMontoCanceladoVentasCliente(int idCliente, double montoACancelar) async {
    final conexion = await _conexion;

    try {
      await conexion.execute('BEGIN');

      final ventasPendientes = await obtenerVentasDeCliente(idCliente);

      if (ventasPendientes.isEmpty) {
        await conexion.execute('ROLLBACK');
        throw NotFoundException('El cliente no tiene ventas pendientes');
      }

      double montoRestante = montoACancelar;

      for (final venta in ventasPendientes) {
        if (montoRestante <= 0) break;

        final pendiente = venta.montoTotal - venta.montoCancelado;
        if (pendiente <= 0) continue;

        if (montoRestante >= pendiente) {
          await conexion.execute(
            Sql.named('''
              UPDATE ventas
              SET monto_cancelado = monto_total, estado = @estado, actualizado_en = CURRENT_TIMESTAMP
              WHERE id_venta = @id
            '''),
            parameters: {'id': venta.idVenta, 'estado': EstadoVenta.COMPLETADA.name},
          );

          montoRestante -= pendiente;
        } else {
          await conexion.execute(
            Sql.named('UPDATE ventas SET monto_cancelado = monto_cancelado + @monto, actualizado_en = CURRENT_TIMESTAMP WHERE id_venta = @id'),
            parameters: {'monto': montoRestante, 'id': venta.idVenta},
          );

          montoRestante = 0;
        }
      }

      await conexion.execute('COMMIT');
    } catch (e) {
      await conexion.execute('ROLLBACK');

      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al cancelar deudas del cliente: $e');
    }
  }

  @override
  Future<List<DetalleVentaEntity>> obtenerDetallesPorVenta(int idVenta) async {
    final conexion = await _conexion;

    try {
      final detallesEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM detalle_ventas WHERE id_venta = @id'),
        parameters: {'id': idVenta},
      );

      return detallesEncontrados
          .map((fila) => DetalleVentaMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener detalles de venta: $e');
    }
  }

  @override
  Future<void> anularVenta(int idVenta) async {
    final conexion = await _conexion;

    try {
      final ventaAnulada = await conexion.execute(
        Sql.named('''
          UPDATE ventas
          SET estado = @estado, actualizado_en = CURRENT_TIMESTAMP
          WHERE id_venta = @id
        '''),
        parameters: {'id': idVenta, 'estado': EstadoVenta.ANULADA.name},
      );

      if (ventaAnulada.affectedRows == 0) {
        throw NotFoundException('Venta no encontrada');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al anular venta: $e');
    }
  }

  @override
  Future<int> obtenerCantidadVendidaPorLote(int idLote) async {
    final conexion = await _conexion;

    try {
      final cantidadVendida = await conexion.execute(
        Sql.named('''
          SELECT COALESCE(SUM(dv.cantidad), 0) AS total
          FROM detalle_ventas dv
          INNER JOIN ventas v ON dv.id_venta = v.id_venta
          WHERE dv.id_lote = @id_lote
          AND v.estado != @estado
        '''),
        parameters: {'id_lote': idLote, 'estado': EstadoVenta.ANULADA.name},
      );

      return cantidadVendida.first.toColumnMap()['total'] as int;
    } catch (e) {
      throw DatabaseException('Error al obtener cantidad vendida: $e');
    }
  }
}
