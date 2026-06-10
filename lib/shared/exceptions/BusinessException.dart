import 'package:iventi/shared/exceptions/AppException.dart';

class BusinessException extends AppException {
  BusinessException(super.mensaje, {super.descripcion})
      : super(codigo: 'BUSINESS_ERROR');
}
