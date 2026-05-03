import 'package:iventi/shared/exceptions/ValidationException.dart';

class CrearClienteRequest {
  final String? dni;
  final String nombres;
  final String apellidos;
  final String? email;
  final String? telefono;

  CrearClienteRequest({this.dni, required this.nombres, required this.apellidos, this.email, this.telefono}) {
    if (nombres.trim().isEmpty) throw ValidationException('El nombre del cliente es obligatorio');
    if (apellidos.trim().isEmpty) throw ValidationException('El apellido del cliente es obligatorio');
    if (dni != null && dni!.trim().isEmpty) throw ValidationException('El DNI no puede estar vacio');
  }
}
