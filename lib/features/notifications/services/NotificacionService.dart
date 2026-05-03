import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';
import 'package:iventi/features/notifications/dtos/requests/CrearNotificacionRequest.dart';
import 'package:iventi/features/notifications/repositories/NotificacionRepository.dart';
import 'package:iventi/features/inventory/repositories/ProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/LoteRepository.dart';
import 'package:iventi/features/config/repositories/ConfiguracionRepository.dart';

class NotificacionService {
  final NotificacionRepository _notificacionRepository;
  final ProductoRepository _productoRepository;
  final LoteRepository _loteRepository;
  final ConfiguracionRepository _configuracionRepository;

  NotificacionService(
    this._notificacionRepository,
    this._productoRepository,
    this._loteRepository,
    this._configuracionRepository,
  );

  Future<NotificacionEntity> crearNotificacion(CrearNotificacionRequest request) async {
    try {
      return await _notificacionRepository.crearNotificacion(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al crear notificacion: ${e.mensaje}');
    }
  }

  Future<List<NotificacionEntity>> obtenerNotificaciones(int idUsuario) async {
    try {
      return await _notificacionRepository.obtenerNotificaciones(idUsuario);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener notificaciones: ${e.mensaje}');
    }
  }

  Future<List<NotificacionEntity>> obtenerNoLeidas(int idUsuario) async {
    try {
      return await _notificacionRepository.obtenerNotificacionesNoLeidas(idUsuario);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener notificaciones no leidas: ${e.mensaje}');
    }
  }

  Future<int> contarNoLeidas(int idUsuario) async {
    try {
      return await _notificacionRepository.contarNotificacionesNoLeidas(idUsuario);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al contar notificaciones: ${e.mensaje}');
    }
  }

  Future<void> marcarComoLeida(int idNotificacion) async {
    try {
      await _notificacionRepository.marcarComoLeida(idNotificacion);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al marcar notificacion: ${e.mensaje}');
    }
  }

  Future<void> marcarTodasComoLeidas(int idUsuario) async {
    try {
      await _notificacionRepository.marcarTodasComoLeidas(idUsuario);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al marcar notificaciones como leidas: ${e.mensaje}');
    }
  }

  Future<void> eliminarNotificacion(int idNotificacion) async {
    try {
      await _notificacionRepository.eliminarNotificacion(idNotificacion);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al eliminar notificacion: ${e.mensaje}');
    }
  }

  Future<void> limpiarHistorial(int idUsuario) async {
    try {
      await _notificacionRepository.limpiarHistorial(idUsuario);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al limpiar historial: ${e.mensaje}');
    }
  }

  Future<void> generarAlertasStock(int idUsuario) async {
    try {
      final productos = await _productoRepository.obtenerTodosLosProductos();

      for (final producto in productos) {
        if (producto.stockActual <= 0) {
          final request = CrearNotificacionRequest(
            idUsuario: idUsuario,
            idProducto: producto.idProducto!,
            idLote: null,
            tipo: TipoNotificacion.STOCK_AGOTADO,
            titulo: 'Stock agotado',
            contenido: '${producto.nombre} no tiene stock disponible',
          );

          await _notificacionRepository.crearNotificacion(request);

        } else if (producto.stockActual <= producto.stockMinimo) {
          final request = CrearNotificacionRequest(
            idUsuario: idUsuario,
            idProducto: producto.idProducto!,
            idLote: null,
            tipo: TipoNotificacion.STOCK_BAJO,
            titulo: 'Stock bajo',
            contenido: '${producto.nombre} tiene solo ${producto.stockActual} unidades',
          );

          await _notificacionRepository.crearNotificacion(request);
        }
      }

    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar alertas de stock: ${e.mensaje}');
    }
  }

  Future<void> generarAlertasVencimiento(int idUsuario) async {
    try {
      final configuracionVencimiento = await _configuracionRepository.obtenerConfiguracion(idUsuario, 'dias_vencimiento');
      final dias = configuracionVencimiento != null ? int.tryParse(configuracionVencimiento.valor) ?? 8 : 8;

      final lotes = await _loteRepository.obtenerLotesProximosAVencer(dias);

      for (final lote in lotes) {
        final request = CrearNotificacionRequest(
          idUsuario: idUsuario,
          idProducto: lote.idProducto,
          idLote: lote.idLote,
          tipo: TipoNotificacion.PROXIMO_VENCER,
          titulo: 'Proximo a vencer',
          contenido: 'Lote ${lote.idLote} del producto ${lote.idProducto} vence pronto',
        );

        await _notificacionRepository.crearNotificacion(request);
      }

    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar alertas de vencimiento: ${e.mensaje}');
    }
  }
}
