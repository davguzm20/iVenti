import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';

class NotificacionResponse {
  final int idNotificacion;
  final int idUsuario;
  final int? idProducto;
  final int? idLote;
  final TipoNotificacion tipo;
  final String titulo;
  final String contenido;
  final bool leida;
  final DateTime creadoEn;

  NotificacionResponse({
    required this.idNotificacion,
    required this.idUsuario,
    this.idProducto,
    this.idLote,
    required this.tipo,
    required this.titulo,
    required this.contenido,
    required this.leida,
    required this.creadoEn,
  });
}
