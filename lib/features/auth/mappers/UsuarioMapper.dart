import 'package:iventi/shared/utils/pg_helpers.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/responses/UsuarioResponse.dart';
import 'package:iventi/features/auth/enums/TipoRol.dart';

class UsuarioMapper {
  static UsuarioEntity fromMap(Map<String, dynamic> map) {
    return UsuarioEntity(
      idUsuario: map['id_usuario'] as int,
      idRol: _parseRol(pgString(map['id_rol'])),
      nombre: map['nombre'] as String,
      email: map['email'] as String,
      pin: map['pin'] as String,
      esActivo: map['es_activo'] as bool,
      creadoEn: map['creado_en'] as DateTime,
      actualizadoEn: map['actualizado_en'] as DateTime?,
    );
  }

  static Map<String, dynamic> toMap(UsuarioEntity entity) {
    return {
      'id_rol': entity.idRol.name,
      'nombre': entity.nombre,
      'email': entity.email,
      'pin': entity.pin,
      'es_activo': entity.esActivo,
    };
  }

  static UsuarioResponse toResponse(UsuarioEntity entity) {
    return UsuarioResponse(
      idUsuario: entity.idUsuario!,
      idRol: entity.idRol,
      nombre: entity.nombre,
      email: entity.email,
      esActivo: entity.esActivo,
      creadoEn: entity.creadoEn,
      actualizadoEn: entity.actualizadoEn,
    );
  }

  static TipoRol _parseRol(String rol) {
    return rol == 'ADMINISTRADOR' ? TipoRol.ADMINISTRADOR : TipoRol.OPERATIVO;
  }
}
