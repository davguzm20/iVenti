import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/dtos/responses/LoteResponse.dart';

class LoteMapper {
  static LoteEntity fromMap(Map<String, dynamic> map) {
    return LoteEntity(
      idLote: map['id_lote'] as int,
      idProducto: map['id_producto'] as int,
      fechaCompra: map['fecha_compra'] as DateTime,
      fechaVencimiento: (map['fecha_vencimiento'] as DateTime?),
      cantidadActual: map['cantidad_actual'] as int,
      cantidadComprada: map['cantidad_comprada'] as int,
      cantidadPerdida: map['cantidad_perdida'] as int,
      precioCompra: double.parse(map['precio_compra'].toString()),
      esActivo: map['es_activo'] as bool,
      creadoEn: map['creado_en'] as DateTime,
      actualizadoEn: map['actualizado_en'] as DateTime?,
    );
  }

  static Map<String, dynamic> toMap(LoteEntity entity) {
    return {
      'id_producto': entity.idProducto,
      'fecha_compra': entity.fechaCompra,
      'fecha_vencimiento': entity.fechaVencimiento,
      'cantidad_actual': entity.cantidadActual,
      'cantidad_comprada': entity.cantidadComprada,
      'cantidad_perdida': entity.cantidadPerdida,
      'precio_compra': entity.precioCompra,
      'es_activo': entity.esActivo,
    };
  }

  static LoteResponse toResponse(LoteEntity entity) {
    return LoteResponse(
      idLote: entity.idLote!,
      idProducto: entity.idProducto,
      fechaCompra: entity.fechaCompra,
      fechaVencimiento: entity.fechaVencimiento,
      cantidadActual: entity.cantidadActual,
      cantidadComprada: entity.cantidadComprada,
      cantidadPerdida: entity.cantidadPerdida,
      precioCompra: entity.precioCompra,
      esActivo: entity.esActivo,
      creadoEn: entity.creadoEn,
      actualizadoEn: entity.actualizadoEn,
    );
  }
}
