class ReciboResponse {
  final int idRecibo;
  final int idVenta;
  final int idUsuario;
  final double montoCancelado;
  final DateTime pagadoEn;
  final DateTime creadoEn;

  ReciboResponse({
    required this.idRecibo,
    required this.idVenta,
    required this.idUsuario,
    required this.montoCancelado,
    required this.pagadoEn,
    required this.creadoEn,
  });
}
