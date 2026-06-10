import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/dtos/responses/ReciboResponse.dart';

class ReciboMapper {
  static ReciboEntity fromMap(Map<String, dynamic> map) {
    return ReciboEntity(
      idRecibo: map['id_recibo'] as int,
      idVenta: map['id_venta'] as int,
      idUsuario: map['id_usuario'] as int,
      montoCancelado: double.parse(map['monto_cancelado'].toString()),
      pagadoEn: map['pagado_en'] as DateTime,
      creadoEn: map['creado_en'] as DateTime,
    );
  }

  static Map<String, dynamic> toMap(ReciboEntity entity) {
    return {
      'id_venta': entity.idVenta,
      'id_usuario': entity.idUsuario,
      'monto_cancelado': entity.montoCancelado,
      'pagado_en': entity.pagadoEn,
    };
  }

  static ReciboResponse toResponse(ReciboEntity entity) {
    return ReciboResponse(
      idRecibo: entity.idRecibo!,
      idVenta: entity.idVenta,
      idUsuario: entity.idUsuario,
      montoCancelado: entity.montoCancelado,
      pagadoEn: entity.pagadoEn,
      creadoEn: entity.creadoEn,
    );
  }
}
