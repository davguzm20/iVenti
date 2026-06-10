import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/dtos/requests/CrearNotificacionRequest.dart';

abstract class INotificacionRepository {
  Future<NotificacionEntity> crearNotificacion(CrearNotificacionRequest request);
  Future<List<NotificacionEntity>> obtenerNotificaciones(int idUsuario);
  Future<List<NotificacionEntity>> obtenerNotificacionesNoLeidas(int idUsuario);
  Future<int> contarNotificacionesNoLeidas(int idUsuario);
  Future<void> marcarComoLeida(int idNotificacion);
  Future<void> marcarTodasComoLeidas(int idUsuario);
  Future<void> eliminarNotificacion(int idNotificacion);
  Future<void> limpiarHistorial(int idUsuario);
}
