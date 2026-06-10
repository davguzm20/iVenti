import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/dtos/requests/CrearNotificacionRequest.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';

class NotificacionController {
  final NotificacionService _notificacionService;

  NotificacionController(this._notificacionService);

  Future<NotificacionEntity> crearNotificacion(CrearNotificacionRequest request) {
    return _notificacionService.crearNotificacion(request);
  }

  Future<List<NotificacionEntity>> obtenerNotificaciones(int idUsuario) {
    return _notificacionService.obtenerNotificaciones(idUsuario);
  }

  Future<List<NotificacionEntity>> obtenerNoLeidas(int idUsuario) {
    return _notificacionService.obtenerNoLeidas(idUsuario);
  }

  Future<int> contarNoLeidas(int idUsuario) {
    return _notificacionService.contarNoLeidas(idUsuario);
  }

  Future<void> marcarComoLeida(int idNotificacion) {
    return _notificacionService.marcarComoLeida(idNotificacion);
  }

  Future<void> marcarTodasComoLeidas(int idUsuario) {
    return _notificacionService.marcarTodasComoLeidas(idUsuario);
  }

  Future<void> eliminarNotificacion(int idNotificacion) {
    return _notificacionService.eliminarNotificacion(idNotificacion);
  }

  Future<void> limpiarHistorial(int idUsuario) {
    return _notificacionService.limpiarHistorial(idUsuario);
  }

  Future<void> generarAlertasStock(int idUsuario) {
    return _notificacionService.generarAlertasStock(idUsuario);
  }

  Future<void> generarAlertasVencimiento(int idUsuario) {
    return _notificacionService.generarAlertasVencimiento(idUsuario);
  }
}
