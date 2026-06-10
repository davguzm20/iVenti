import 'package:iventi/shared/exceptions/AppException.dart';

class NotFoundException extends AppException {
  NotFoundException(super.mensaje) : super(codigo: 'NOT_FOUND');
}
