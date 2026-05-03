import 'package:iventi/shared/exceptions/AppException.dart';

class AuthenticationException extends AppException {
  AuthenticationException(super.mensaje) : super(codigo: 'AUTH_ERROR');
}
