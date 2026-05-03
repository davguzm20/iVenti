import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/dtos/responses/UnidadResponse.dart';

class UnidadMapper {
  static UnidadEntity fromMap(Map<String, dynamic> map) {
    return UnidadEntity(
      idUnidad: map['id_unidad'] as int,
      nombre: map['nombre'] as String,
      abreviatura: map['abreviatura'] as String,
      esActivo: map['es_activo'] as bool,
      creadoEn: map['creado_en'] as DateTime,
    );
  }

  static Map<String, dynamic> toMap(UnidadEntity entity) {
    return {
      'nombre': entity.nombre,
      'abreviatura': entity.abreviatura,
      'es_activo': entity.esActivo,
    };
  }

  static UnidadResponse toResponse(UnidadEntity entity) {
    return UnidadResponse(
      idUnidad: entity.idUnidad!,
      nombre: entity.nombre,
      abreviatura: entity.abreviatura,
      esActivo: entity.esActivo,
      creadoEn: entity.creadoEn,
    );
  }
}
