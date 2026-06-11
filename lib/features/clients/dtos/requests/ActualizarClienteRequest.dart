import 'package:iventi/shared/exceptions/ValidationException.dart';

class ActualizarClienteRequest {
  final int idCliente;
  final String? dni;
  final String nombres;
  final String? email;
  final String? telefono;

  ActualizarClienteRequest({required this.idCliente, this.dni, required this.nombres, this.email, this.telefono}) {
    if (nombres.trim().isEmpty) throw ValidationException('El nombre del cliente es obligatorio');
  }
}
