import 'package:iventi/features/config/entities/ConfiguracionEntity.dart';
import 'package:iventi/features/config/dtos/responses/ConfiguracionResponse.dart';

class ConfiguracionMapper {
  static ConfiguracionEntity fromMap(Map<String, dynamic> map) {
    return ConfiguracionEntity(
      idConfiguracion: map['id_configuracion'] as int,
      idUsuario: map['id_usuario'] as int,
      clave: map['clave'] as String,
      valor: map['valor'] as String,
      creadoEn: map['creado_en'] as DateTime,
      actualizadoEn: map['actualizado_en'] as DateTime?,
    );
  }

  static Map<String, dynamic> toMap(ConfiguracionEntity entity) {
    return {
      'id_usuario': entity.idUsuario,
      'clave': entity.clave,
      'valor': entity.valor,
    };
  }

  static ConfiguracionResponse toResponse(ConfiguracionEntity entity) {
    return ConfiguracionResponse(
      idConfiguracion: entity.idConfiguracion!,
      idUsuario: entity.idUsuario,
      clave: entity.clave,
      valor: entity.valor,
      creadoEn: entity.creadoEn,
      actualizadoEn: entity.actualizadoEn,
    );
  }
}
