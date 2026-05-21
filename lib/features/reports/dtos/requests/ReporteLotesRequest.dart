import 'package:iventi/shared/exceptions/ValidationException.dart';

class ReporteLotesRequest {
  final DateTime fechaInicio;
  final DateTime fechaFinal;
  final String? tipo;

  ReporteLotesRequest({
    required this.fechaInicio,
    required this.fechaFinal,
    this.tipo,
  }) {
    if (fechaInicio.isAfter(fechaFinal)) {
      throw ValidationException('La fecha de inicio no puede ser posterior a la fecha final');
    }
  }
}
