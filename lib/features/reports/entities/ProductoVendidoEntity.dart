class ProductoVendidoEntity {
  final String producto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const ProductoVendidoEntity({
    required this.producto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
}
