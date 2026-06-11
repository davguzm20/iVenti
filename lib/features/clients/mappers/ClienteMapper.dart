import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/dtos/responses/ClienteResponse.dart';
import 'package:iventi/shared/utils/DniEncryptor.dart';

class ClienteMapper {
  static ClienteEntity fromMap(Map<String, dynamic> map) {
    final rawDni = map['dni'] as String?;
    return ClienteEntity(
      idCliente: map['id_cliente'] as int,
      dni: rawDni != null ? DniEncryptor.decryptAES(rawDni) : null,
      nombres: map['nombres'] as String,
      email: map['email'] as String?,
      telefono: map['telefono'] as String?,
      esDeudor: map['es_deudor'] as bool,
      esActivo: map['es_activo'] as bool,
      creadoEn: map['creado_en'] as DateTime,
      actualizadoEn: map['actualizado_en'] as DateTime?,
    );
  }

  static Map<String, dynamic> toMap(ClienteEntity entity) {
    return {
      'dni': entity.dni != null ? DniEncryptor.encryptAES(entity.dni!) : null,
      'nombres': entity.nombres,
      'email': entity.email,
      'telefono': entity.telefono,
      'es_deudor': entity.esDeudor,
    };
  }

  static ClienteResponse toResponse(ClienteEntity entity) {
    return ClienteResponse(
      idCliente: entity.idCliente!,
      dni: entity.dni,
      nombres: entity.nombres,
      email: entity.email,
      telefono: entity.telefono,
      esDeudor: entity.esDeudor,
      esActivo: entity.esActivo,
      creadoEn: entity.creadoEn,
      actualizadoEn: entity.actualizadoEn,
    );
  }
}
