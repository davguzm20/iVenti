import 'package:iventi/shared/exceptions/AppException.dart';

class NetworkException extends AppException {
  NetworkException(super.mensaje) : super(codigo: 'NETWORK_ERROR');
}
