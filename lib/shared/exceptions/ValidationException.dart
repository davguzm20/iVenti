import 'package:iventi/shared/exceptions/AppException.dart';

class ValidationException extends AppException {
  ValidationException(String mensaje, {String? descripcion})
      : super(mensaje, descripcion: descripcion, codigo: 'VALIDATION_ERROR');
}
