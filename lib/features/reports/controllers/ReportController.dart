import 'package:iventi/features/reports/entities/VentaReportEntity.dart';
import 'package:iventi/features/reports/entities/ProductoVendidoEntity.dart';
import 'package:iventi/features/reports/entities/LoteReportEntity.dart';
import 'package:iventi/features/reports/services/ReportService.dart';

class ReportController {
  final ReportService _service;

  ReportController(this._service);

  Future<List<VentaReportEntity>> generarVentas({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
    String? tipo,
  }) {
    return _service.generarReporteVentas(
      fechaInicio: fechaInicio,
      fechaFinal: fechaFinal,
      tipo: tipo,
    );
  }

  Future<List<ProductoVendidoEntity>> generarProductosVendidos({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
  }) {
    return _service.generarReporteProductosVendidos(
      fechaInicio: fechaInicio,
      fechaFinal: fechaFinal,
    );
  }

  Future<List<LoteReportEntity>> generarLotes({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
    String? tipo,
  }) {
    return _service.generarReporteLotes(
      fechaInicio: fechaInicio,
      fechaFinal: fechaFinal,
      tipo: tipo,
    );
  }

  Future<List<LoteReportEntity>> generarProximosVencer(int dias) {
    return _service.generarReporteProximosVencer(dias);
  }

  Future<List<LoteReportEntity>> generarInventarioGeneral(DateTime fecha) {
    return _service.generarReporteInventarioGeneral(fecha);
  }
}
