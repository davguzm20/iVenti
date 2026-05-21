class VentaReportResponse {
  final int idVenta;
  final String codigoBoleta;
  final String cliente;
  final DateTime fecha;
  final double montoTotal;
  final double montoCancelado;
  final String tipo;

  const VentaReportResponse({
    required this.idVenta,
    required this.codigoBoleta,
    required this.cliente,
    required this.fecha,
    required this.montoTotal,
    required this.montoCancelado,
    required this.tipo,
  });
}
