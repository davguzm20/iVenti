import 'package:iventi/shared/exceptions/AppException.dart';

class DatabaseException extends AppException {
  DatabaseException(super.mensaje) : super(codigo: 'DATABASE_ERROR');
}
