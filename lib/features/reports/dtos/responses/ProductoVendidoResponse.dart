class ProductoVendidoResponse {
  final String producto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const ProductoVendidoResponse({
    required this.producto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
}
