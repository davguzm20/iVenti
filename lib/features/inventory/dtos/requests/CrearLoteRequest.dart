import 'package:iventi/shared/exceptions/ValidationException.dart';

class CrearLoteRequest {
  final int idProducto;
  final DateTime fechaCompra;
  final DateTime fechaVencimiento;
  final int cantidadComprada;
  final int cantidadPerdida;
  final double precioCompra;

  CrearLoteRequest({
    required this.idProducto,
    required this.fechaCompra,
    required this.fechaVencimiento,
    required this.cantidadComprada,
    this.cantidadPerdida = 0,
    required this.precioCompra,
  }) {
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
