import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearReciboRequest.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';
import 'package:iventi/features/sales/repositories/IVentaRepository.dart';
import 'package:iventi/features/sales/repositories/IReciboRepository.dart';
import 'package:iventi/features/clients/repositories/IClienteRepository.dart';

class PagoService {
  final PostgresDatasource _datasource;
  final IVentaRepository _ventaRepository;
  final IReciboRepository _reciboRepository;
  final IClienteRepository _clienteRepository;

  PagoService(
    this._datasource,
    this._ventaRepository,
    this._reciboRepository,
    this._clienteRepository,
  );

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

    try {
      final clienteExistente = await _clienteRepository.obtenerClientePorId(idCliente);

      if (clienteExistente == null) {
        throw BusinessException('Cliente no encontrado');
      }

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
}
