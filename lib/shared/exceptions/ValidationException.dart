import 'package:iventi/shared/exceptions/AppException.dart';

class ValidationException extends AppException {
  ValidationException(super.mensaje) : super(codigo: 'VALIDATION_ERROR');
}
