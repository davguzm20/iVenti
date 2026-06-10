import 'package:iventi/shared/exceptions/ValidationException.dart';

class ReporteProximosVencerRequest {
  final int dias;

  ReporteProximosVencerRequest({required this.dias}) {
    if (dias <= 0) {
      throw ValidationException('El número de días debe ser mayor a 0');
    }
  }
}
