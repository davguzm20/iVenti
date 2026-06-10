import 'package:iventi/shared/exceptions/ValidationException.dart';

class CrearReciboRequest {
  final int idVenta;
  final int idUsuario;
  final double montoCancelado;

  CrearReciboRequest({
    required this.idVenta,
    required this.idUsuario,
    required this.montoCancelado,
  }) {
    if (montoCancelado <= 0) throw ValidationException('El monto cancelado debe ser mayor a 0');
  }
}
