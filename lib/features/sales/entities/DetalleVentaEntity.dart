class DetalleVentaEntity {
  final int? idDetalleVenta;
  final int idVenta;
  final int idLote;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final double descuento;
  final DateTime creadoEn;

  DetalleVentaEntity({
    this.idDetalleVenta,
    required this.idVenta,
    required this.idLote,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    required this.descuento,
    required this.creadoEn,
  });
}
