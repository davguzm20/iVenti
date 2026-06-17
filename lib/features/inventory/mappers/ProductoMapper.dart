import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/dtos/responses/ProductoResponse.dart';

class ProductoMapper {
  static ProductoEntity fromMap(Map<String, dynamic> map) {
    return ProductoEntity(
      idProducto: map['id_producto'] as int,
      idUnidad: map['id_unidad'] as int,
      codigo: map['codigo'] as String?,
      nombre: map['nombre'] as String,
      precio: double.parse(map['precio'].toString()),
      stockActual: (map['stock_actual'] as int?) ?? 0,
      stockMinimo: (map['stock_minimo'] as int?) ?? 0,
      rutaImagen: map['ruta_imagen'] as String?,
      esActivo: (map['es_activo'] as bool?) ?? true,
      creadoEn: (map['creado_en'] as DateTime?) ?? DateTime.now(),
      actualizadoEn: map['actualizado_en'] as DateTime?,
    );
  }

  static Map<String, dynamic> toMap(ProductoEntity entity) {
    return {
      'id_unidad': entity.idUnidad,
      'codigo': entity.codigo,
      'nombre': entity.nombre,
      'precio': entity.precio,
      'stock_actual': entity.stockActual,
      'stock_minimo': entity.stockMinimo,
      'ruta_imagen': entity.rutaImagen,
      'es_activo': entity.esActivo,
    };
  }

  static ProductoResponse toResponse(ProductoEntity entity) {
    return ProductoResponse(
      idProducto: entity.idProducto!,
      idUnidad: entity.idUnidad,
      codigo: entity.codigo,
      nombre: entity.nombre,
      precio: entity.precio,
      stockActual: entity.stockActual,
      stockMinimo: entity.stockMinimo,
      rutaImagen: entity.rutaImagen,
      esActivo: entity.esActivo,
      creadoEn: entity.creadoEn,
      actualizadoEn: entity.actualizadoEn,
    );
  }
}
