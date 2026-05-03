import 'package:iventi/shared/exceptions/ValidationException.dart';

class ActualizarLoteRequest {
  final int idProducto;
  final int idLote;
  final int cantidadActual;
  final int cantidadComprada;
  final int cantidadPerdida;
  final double precioCompra;
  final DateTime fechaCompra;
  final DateTime fechaVencimiento;

  ActualizarLoteRequest({
    required this.idProducto,
    required this.idLote,
    required this.cantidadActual,
    required this.cantidadComprada,
    this.cantidadPerdida = 0,
    required this.precioCompra,
    required this.fechaCompra,
    required this.fechaVencimiento,
  }) {
    if (cantidadActual < 0) {
      throw ValidationException('La cantidad actual no puede ser negativa');
    }
    if (cantidadComprada <= 0) {
      throw ValidationException('La cantidad comprada debe ser mayor a 0');
    }
    if (cantidadPerdida < 0) {
      throw ValidationException('La cantidad perdida no puede ser negativa');
    }
    if (precioCompra < 0) {
      throw ValidationException('El precio de compra no puede ser negativo');
    }
    if (fechaVencimiento.isBefore(fechaCompra)) {
      throw ValidationException('La fecha de vencimiento no puede ser anterior a la fecha de compra');
    }
  }
}
