import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/dtos/responses/CategoriaResponse.dart';

class CategoriaMapper {
  static CategoriaEntity fromMap(Map<String, dynamic> map) {
    return CategoriaEntity(
      idCategoria: map['id_categoria'] as int,
      nombre: map['nombre'] as String,
      esActivo: map['es_activo'] as bool,
      creadoEn: map['creado_en'] as DateTime,
      actualizadoEn: map['actualizado_en'] as DateTime?,
    );
  }

  static Map<String, dynamic> toMap(CategoriaEntity entity) {
    return {
      'nombre': entity.nombre,
      'es_activo': entity.esActivo,
    };
  }

  static CategoriaResponse toResponse(CategoriaEntity entity) {
    return CategoriaResponse(
      idCategoria: entity.idCategoria!,
      nombre: entity.nombre,
      esActivo: entity.esActivo,
      creadoEn: entity.creadoEn,
      actualizadoEn: entity.actualizadoEn,
    );
  }
}
