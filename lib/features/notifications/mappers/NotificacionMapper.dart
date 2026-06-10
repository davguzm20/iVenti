import 'package:iventi/shared/utils/PgHelper.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/dtos/responses/NotificacionResponse.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';

class NotificacionMapper {
  static NotificacionEntity fromMap(Map<String, dynamic> map) {
    return NotificacionEntity(
      idNotificacion: map['id_notificacion'] as int,
      idUsuario: map['id_usuario'] as int,
      idProducto: map['id_producto'] as int?,
      idLote: map['id_lote'] as int?,
      tipo: _parseTipo(PgHelper.string(map['tipo'])),
      titulo: map['titulo'] as String,
      contenido: map['contenido'] as String,
      leida: map['leida'] as bool,
      creadoEn: map['creado_en'] as DateTime,
    );
  }

  static Map<String, dynamic> toMap(NotificacionEntity entity) {
    return {
      'id_usuario': entity.idUsuario,
      'id_producto': entity.idProducto,
      'id_lote': entity.idLote,
      'tipo': entity.tipo.name,
      'titulo': entity.titulo,
      'contenido': entity.contenido,
      'leida': entity.leida,
    };
  }

  static NotificacionResponse toResponse(NotificacionEntity entity) {
    return NotificacionResponse(
      idNotificacion: entity.idNotificacion!,
      idUsuario: entity.idUsuario,
      idProducto: entity.idProducto,
      idLote: entity.idLote,
      tipo: entity.tipo,
      titulo: entity.titulo,
      contenido: entity.contenido,
      leida: entity.leida,
      creadoEn: entity.creadoEn,
    );
  }

  static TipoNotificacion _parseTipo(String tipo) {
    switch (tipo) {
      case 'STOCK_AGOTADO':
        return TipoNotificacion.STOCK_AGOTADO;
      case 'PROXIMO_VENCER':
        return TipoNotificacion.PROXIMO_VENCER;
      case 'VENCIDO':
        return TipoNotificacion.VENCIDO;
      default:
        return TipoNotificacion.STOCK_BAJO;
    }
  }
}
