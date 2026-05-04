class LoteReportEntity {
  final int idLote;
  final String producto;
  final int cantidadActual;
  final int cantidadComprada;
  final DateTime? fechaVencimiento;

  const LoteReportEntity({
    required this.idLote,
    required this.producto,
    required this.cantidadActual,
    required this.cantidadComprada,
    this.fechaVencimiento,
  });
}
