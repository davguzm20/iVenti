import 'package:iventi/features/reports/entities/ProductoVendidoEntity.dart';
import 'package:iventi/features/reports/dtos/responses/ProductoVendidoResponse.dart';

class ProductoVendidoMapper {
  static ProductoVendidoEntity fromResponse(ProductoVendidoResponse response) {
    return ProductoVendidoEntity(
      producto: response.producto,
      cantidad: response.cantidad,
      precioUnitario: response.precioUnitario,
      subtotal: response.subtotal,
    );
  }

  static ProductoVendidoResponse fromMap(Map<String, dynamic> map) {
    return ProductoVendidoResponse(
      producto: map['producto'] as String,
      cantidad: (map['cantidad'] as num).toInt(),
      precioUnitario: (map['precio_unitario'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
    );
  }
}
