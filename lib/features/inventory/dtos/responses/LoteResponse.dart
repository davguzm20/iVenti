class LoteResponse {
  final int idLote;
  final int idProducto;
  final DateTime fechaCompra;
  final DateTime fechaVencimiento;
  final int cantidadActual;
  final int cantidadComprada;
  final int cantidadPerdida;
  final double precioCompra;
  final bool esActivo;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  LoteResponse({
    required this.idLote,
    required this.idProducto,
    required this.fechaCompra,
    required this.fechaVencimiento,
    required this.cantidadActual,
    required this.cantidadComprada,
    required this.cantidadPerdida,
    required this.precioCompra,
    required this.esActivo,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
