import '../enums/TipoNotificacion.dart';

class NotificacionEntity {
  final int? idNotificacion;
  final int idUsuario;
  final int? idProducto;
  final int? idLote;
  final TipoNotificacion tipo;
  final String titulo;
  final String contenido;
  final bool leida;
  final DateTime creadoEn;

  NotificacionEntity({
    this.idNotificacion,
    required this.idUsuario,
    this.idProducto,
    this.idLote,
    required this.tipo,
    required this.titulo,
    required this.contenido,
    this.leida = false,
    required this.creadoEn,
  });
}
