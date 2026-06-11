import 'package:iventi/shared/exceptions/ValidationException.dart';

class LoginRequest {
  final String email;
  final String pin;

  LoginRequest({required this.email, required this.pin}) {
    if (email.trim().isEmpty) throw ValidationException('El email es obligatorio');
    if (pin.trim().isEmpty) throw ValidationException('El PIN es obligatorio');
  }
}
