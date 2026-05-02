import '../enums/EstadoVenta.dart';

class VentaEntity {
  final int? idVenta;
  final int? idCliente;
  final int idUsuario;
  final DateTime vendidoEn;
  final double montoTotal;
  final double montoCancelado;
  final EstadoVenta estado;
  final bool esCredito;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  VentaEntity({
    this.idVenta,
    this.idCliente,
    required this.idUsuario,
    required this.vendidoEn,
    required this.montoTotal,
    required this.montoCancelado,
    required this.estado,
    required this.esCredito,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
