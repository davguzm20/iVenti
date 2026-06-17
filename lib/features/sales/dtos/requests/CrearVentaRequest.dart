import 'package:iventi/shared/exceptions/ValidationException.dart';

class DetalleVentaRequest {
  final int idProducto;
  final int idLote;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final double descuento;

  DetalleVentaRequest({
    required this.idProducto,
    required this.idLote,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    required this.descuento,
  }) {
    if (cantidad <= 0) throw ValidationException('La cantidad debe ser mayor a 0');
    if (precioUnitario < 0) throw ValidationException('El precio unitario no puede ser negativo');
    if (subtotal < 0) throw ValidationException('El subtotal no puede ser negativo');
  }
}

class CrearVentaRequest {
  final int? idCliente;
  final int idUsuario;
  final double montoTotal;
  final double montoCancelado;
  final bool esCredito;
  final List<DetalleVentaRequest> detalles;

  CrearVentaRequest({
    this.idCliente,
    required this.idUsuario,
    required this.montoTotal,
    this.montoCancelado = 0,
    this.esCredito = false,
    required this.detalles,
  }) {
    if (idCliente == null) throw ValidationException('El cliente es obligatorio para crear una venta');
    if (montoTotal < 0) throw ValidationException('El monto total no puede ser negativo');
    if (montoCancelado < 0) throw ValidationException('El monto cancelado no puede ser negativo');
    if (detalles.isEmpty) throw ValidationException('La venta debe tener al menos un detalle');
    if (!esCredito && montoCancelado < montoTotal) {
      throw ValidationException('En ventas al contado el monto cancelado debe ser igual al total');
    }
  }
}
