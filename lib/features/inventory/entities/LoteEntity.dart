class LoteEntity {
  final int? idLote;
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

  LoteEntity({
    this.idLote,
    required this.idProducto,
    required this.fechaCompra,
    required this.fechaVencimiento,
    required this.cantidadActual,
    required this.cantidadComprada,
    required this.cantidadPerdida,
    required this.precioCompra,
    this.esActivo = true,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
