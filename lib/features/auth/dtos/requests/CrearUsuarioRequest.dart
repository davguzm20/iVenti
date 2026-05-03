import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/auth/enums/TipoRol.dart';

class CrearUsuarioRequest {
  final TipoRol idRol;
  final String nombre;
  final String email;
  final String pin;

  CrearUsuarioRequest({required this.idRol, required this.nombre, required this.email, required this.pin}) {
    if (nombre.trim().isEmpty) throw ValidationException('El nombre es obligatorio');
    if (email.trim().isEmpty) throw ValidationException('El email es obligatorio');
    if (pin.trim().isEmpty || pin.length != 6) throw ValidationException('El PIN debe tener 6 digitos');
  }
}
