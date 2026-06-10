import 'package:iventi/shared/exceptions/ValidationException.dart';

class ReporteProductosVendidosRequest {
  final DateTime fechaInicio;
  final DateTime fechaFinal;

  ReporteProductosVendidosRequest({
    required this.fechaInicio,
    required this.fechaFinal,
  }) {
    if (fechaInicio.isAfter(fechaFinal)) {
      throw ValidationException('La fecha de inicio no puede ser posterior a la fecha final');
    }
  }
}
