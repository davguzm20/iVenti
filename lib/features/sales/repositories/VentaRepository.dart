import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';
import 'package:iventi/features/sales/mappers/VentaMapper.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';
import 'package:iventi/features/sales/repositories/ReciboRepository.dart';
import 'package:iventi/features/sales/repositories/IVentaRepository.dart';

class VentaRepository implements IVentaRepository {
  final PostgresDatasource _datasource;

  VentaRepository(this._datasource);

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

      final detalles = request.detalles;

      final detalleValues = <String>[];
      final detalleParams = <String, dynamic>{'id_venta': idVenta};
      for (var i = 0; i < detalles.length; i++) {
        final d = detalles[i];
        detalleValues.add('(@id_venta, @lote_$i, @cant_$i, @precio_$i, @sub_$i, @desc_$i, CURRENT_TIMESTAMP)');
        detalleParams['lote_$i'] = d.idLote;
        detalleParams['cant_$i'] = d.cantidad;
        detalleParams['precio_$i'] = d.precioUnitario;
        detalleParams['sub_$i'] = d.subtotal;
        detalleParams['desc_$i'] = d.descuento;
      }
      await conexion.execute(
        Sql.named('INSERT INTO detalle_ventas (id_venta, id_lote, cantidad, precio_unitario, subtotal, descuento, creado_en) VALUES ${detalleValues.join(', ')}'),
        parameters: detalleParams,
      );

      final loteCases = <String>[];
      final loteInClauses = <String>[];
      final loteParams = <String, dynamic>{};
      for (var i = 0; i < detalles.length; i++) {
        final d = detalles[i];
        loteCases.add('WHEN @l_$i THEN cantidad_actual - @c_$i');
        loteInClauses.add('@l_$i');
        loteParams['l_$i'] = d.idLote;
        loteParams['c_$i'] = d.cantidad;
      }
      await conexion.execute(
        Sql.named('UPDATE lotes SET cantidad_actual = CASE id_lote ${loteCases.join(' ')} END, actualizado_en = CURRENT_TIMESTAMP WHERE id_lote IN (${loteInClauses.join(', ')})'),
        parameters: loteParams,
      );

      final idsProducto = detalles.map((d) => d.idProducto).toSet().toList();
      final stockInClauses = idsProducto.asMap().entries.map((e) => '@p${e.key}').join(', ');
      final stockParams = <String, dynamic>{};
      for (var i = 0; i < idsProducto.length; i++) {
        stockParams['p$i'] = idsProducto[i];
      }
      await conexion.execute(
        Sql.named('''
          WITH stock_totals AS (
            SELECT id_producto, COALESCE(SUM(cantidad_actual), 0) AS stock_total
            FROM lotes
            WHERE id_producto IN ($stockInClauses) AND es_activo = TRUE
            GROUP BY id_producto
          )
          UPDATE productos p
          SET stock_actual = COALESCE(st.stock_total, 0), actualizado_en = CURRENT_TIMESTAMP
          FROM stock_totals st
          WHERE p.id_producto = st.id_producto
        '''),
        parameters: stockParams,
      );

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
