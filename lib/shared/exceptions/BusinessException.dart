import 'package:iventi/shared/exceptions/AppException.dart';

class BusinessException extends AppException {
  BusinessException(String mensaje, {String? descripcion})
      : super(mensaje, descripcion: descripcion, codigo: 'BUSINESS_ERROR');
}
