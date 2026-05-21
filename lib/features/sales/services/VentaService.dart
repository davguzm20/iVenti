import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';
import 'package:iventi/features/sales/dtos/requests/CrearReciboRequest.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';
import 'package:iventi/features/sales/repositories/VentaRepository.dart';
import 'package:iventi/features/sales/repositories/ReciboRepository.dart';
import 'package:iventi/features/inventory/repositories/ProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/LoteRepository.dart';
import 'package:iventi/features/clients/repositories/ClienteRepository.dart';

class VentaService {
  final PostgresDatasource _datasource;
  final VentaRepository _ventaRepository;
  final ReciboRepository _reciboRepository;
  final ProductoRepository _productoRepository;
  final LoteRepository _loteRepository;
  final ClienteRepository _clienteRepository;

  VentaService(
    this._datasource,
    this._ventaRepository,
    this._reciboRepository,
    this._productoRepository,
    this._loteRepository,
    this._clienteRepository,
  );

  Future<VentaEntity> crearVenta(CrearVentaRequest request) async {
    for (final detalle in request.detalles) {
      final lote = await _loteRepository.obtenerLotePorId(detalle.idProducto, detalle.idLote);

      if (lote == null) {
        throw BusinessException('Lote ${detalle.idLote} no encontrado');
      }

      if (lote.cantidadActual < detalle.cantidad) {
        throw BusinessException(
          'Stock insuficiente en lote ${detalle.idLote}: '
          'disponible ${lote.cantidadActual}, requerido ${detalle.cantidad}',
        );
      }
    }

    try {
      final venta = await _ventaRepository.crearVenta(request);

      if (request.idCliente != null) {
        await _clienteRepository.actualizarEstadoDeudor(request.idCliente!);
      }

      return venta;

    } on DatabaseException catch (e) {
      throw BusinessException('Error al crear venta: ${e.mensaje}');
    }
  }

  Future<VentaEntity?> obtenerVentaPorId(int idVenta) async {
    try {
      return await _ventaRepository.obtenerVentaPorId(idVenta);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener venta: ${e.mensaje}');
    }
  }

  Future<List<VentaEntity>> obtenerVentasFiltradas({
    required int limite,
    required int offset,
    bool? esAlContado,
    DateTime? fechaInicio,
    DateTime? fechaFinal,
  }) async {
    try {
      return await _ventaRepository.obtenerVentasPorFiltros(
        limite: limite,
        offset: offset,
        esAlContado: esAlContado,
        fechaInicio: fechaInicio,
        fechaFinal: fechaFinal,
      );

    } on DatabaseException catch (e) {
      throw BusinessException('Error al filtrar ventas: ${e.mensaje}');
    }
  }

  Future<List<VentaEntity>> obtenerVentasDeCliente(int idCliente) async {
    try {
      return await _ventaRepository.obtenerVentasDeCliente(idCliente);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener ventas del cliente: ${e.mensaje}');
    }
  }

  Future<List<VentaEntity>> obtenerVentasPorFechas(DateTime fechaInicio, DateTime fechaFinal) async {
    try {
      return await _ventaRepository.obtenerVentasPorFechas(fechaInicio, fechaFinal);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener ventas por fechas: ${e.mensaje}');
    }
  }

  Future<List<DetalleVentaEntity>> obtenerDetallesDeVenta(int idVenta) async {
    try {
      return await _ventaRepository.obtenerDetallesPorVenta(idVenta);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener detalles de venta: ${e.mensaje}');
    }
  }

  Future<void> anularVenta(int idVenta) async {
    try {
      final ventaExistente = await _ventaRepository.obtenerVentaPorId(idVenta);

      if (ventaExistente == null) {
        throw BusinessException('Venta no encontrada');
      }

      if (ventaExistente.estado == EstadoVenta.ANULADA) {
        throw BusinessException('La venta ya esta anulada');
      }

      final conexion = await _datasource.connection;

      try {
        await conexion.execute('BEGIN');

        final detalles = await _ventaRepository.obtenerDetallesPorVenta(idVenta);

        for (final detalle in detalles) {
          await conexion.execute(
            Sql.named(
              'UPDATE lotes SET cantidad_actual = cantidad_actual + @cantidad, '
              'actualizado_en = CURRENT_TIMESTAMP WHERE id_lote = @id_lote',
            ),
            parameters: {'cantidad': detalle.cantidad, 'id_lote': detalle.idLote},
          );

          final loteData = await conexion.execute(
            Sql.named('SELECT id_producto FROM lotes WHERE id_lote = @id_lote'),
            parameters: {'id_lote': detalle.idLote},
          );

          final idProducto = loteData.first.toColumnMap()['id_producto'] as int;
          await _productoRepository.actualizarStockActual(idProducto);
        }

        await conexion.execute(
          Sql.named(
            '''UPDATE ventas SET estado = @estado, actualizado_en = CURRENT_TIMESTAMP WHERE id_venta = @id''',
          ),
          parameters: {'estado': EstadoVenta.ANULADA.name, 'id': idVenta},
        );

        await conexion.execute('COMMIT');

      } catch (e) {
        await conexion.execute('ROLLBACK');

        if (e is BusinessException) {
          rethrow;
        }

        throw DatabaseException('Error al anular venta: $e');
      }

      if (ventaExistente.idCliente != null) {
        await _clienteRepository.actualizarEstadoDeudor(ventaExistente.idCliente!);
      }

    } on DatabaseException catch (e) {
      throw BusinessException('Error al anular venta: ${e.mensaje}');
    }
  }

  Future<ReciboEntity> registrarPago(int idVenta, double monto, int idUsuario) async {
    if (monto <= 0) {
      throw BusinessException('El monto debe ser mayor a 0');
    }

    final ventaExistente = await _ventaRepository.obtenerVentaPorId(idVenta);

    if (ventaExistente == null) {
      throw BusinessException('Venta no encontrada');
    }

    if (ventaExistente.estado == EstadoVenta.ANULADA) {
      throw BusinessException('No se puede pagar una venta anulada');
    }

    if (ventaExistente.montoCancelado >= ventaExistente.montoTotal) {
      throw BusinessException('La venta ya esta completamente pagada');
    }

    if (ventaExistente.montoCancelado + monto > ventaExistente.montoTotal) {
      throw BusinessException('El monto excede el saldo pendiente');
    }

    try {
      await _ventaRepository.actualizarMontoCanceladoVenta(idVenta, monto);

      final request = CrearReciboRequest(
        idVenta: idVenta,
        idUsuario: idUsuario,
        montoCancelado: monto,
      );

      final recibo = await _reciboRepository.crearReciboConRequest(request);

      if (ventaExistente.idCliente != null) {
        await _clienteRepository.actualizarEstadoDeudor(ventaExistente.idCliente!);
      }

      return recibo;

    } on DatabaseException catch (e) {
      throw BusinessException('Error al registrar pago: ${e.mensaje}');
    }
  }

  Future<void> registrarPagoCliente(int idCliente, double monto, int idUsuario) async {
    if (monto <= 0) {
      throw BusinessException('El monto debe ser mayor a 0');
    }

    final clienteExistente = await _clienteRepository.obtenerClientePorId(idCliente);

    if (clienteExistente == null) {
      throw BusinessException('Cliente no encontrado');
    }

    try {
      final conexion = await _datasource.connection;

      try {
        await conexion.execute('BEGIN');

        final ventas = await _ventaRepository.obtenerVentasDeCliente(idCliente, esAlContado: true);

        if (ventas.isEmpty) {
          await conexion.execute('ROLLBACK');
          throw BusinessException('El cliente no tiene ventas pendientes');
        }

        double montoRestante = monto;

        for (final venta in ventas) {
          if (montoRestante <= 0) break;

          final pendiente = venta.montoTotal - venta.montoCancelado;
          if (pendiente <= 0) continue;

          if (montoRestante >= pendiente) {
            await conexion.execute(
              Sql.named(
                'UPDATE ventas SET monto_cancelado = monto_total, estado = @estado, '
                'actualizado_en = CURRENT_TIMESTAMP WHERE id_venta = @id',
              ),
              parameters: {'estado': EstadoVenta.COMPLETADA.name, 'id': venta.idVenta},
            );

            await conexion.execute(
              Sql.named(
                'INSERT INTO recibos (id_venta, id_usuario, monto_cancelado, pagado_en, creado_en) '
                'VALUES (@id_venta, @id_usuario, @monto, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
              ),
              parameters: {
                'id_venta': venta.idVenta,
                'id_usuario': idUsuario,
                'monto': pendiente,
              },
            );

            montoRestante -= pendiente;
          } else {
            await conexion.execute(
              Sql.named(
                'UPDATE ventas SET monto_cancelado = monto_cancelado + @monto, '
                'actualizado_en = CURRENT_TIMESTAMP WHERE id_venta = @id',
              ),
              parameters: {'monto': montoRestante, 'id': venta.idVenta},
            );

            await conexion.execute(
              Sql.named(
                'INSERT INTO recibos (id_venta, id_usuario, monto_cancelado, pagado_en, creado_en) '
                'VALUES (@id_venta, @id_usuario, @monto, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
              ),
              parameters: {
                'id_venta': venta.idVenta,
                'id_usuario': idUsuario,
                'monto': montoRestante,
              },
            );

            montoRestante = 0;
          }
        }

        await conexion.execute('COMMIT');

      } catch (e) {
        await conexion.execute('ROLLBACK');

        if (e is BusinessException) {
          rethrow;
        }

        throw DatabaseException('Error al procesar pago del cliente: $e');
      }

      await _clienteRepository.actualizarEstadoDeudor(idCliente);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al procesar pago del cliente: ${e.mensaje}');
    }
  }

  Future<List<ReciboEntity>> obtenerRecibosDeVenta(int idVenta) async {
    try {
      return await _reciboRepository.obtenerRecibosPorVenta(idVenta);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener recibos: ${e.mensaje}');
    }
  }

  Future<int> obtenerCantidadVendidaPorLote(int idLote) async {
    try {
      return await _ventaRepository.obtenerCantidadVendidaPorLote(idLote);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener cantidad vendida: ${e.mensaje}');
    }
  }
}
