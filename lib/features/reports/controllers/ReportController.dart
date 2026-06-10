import 'package:iventi/features/reports/entities/VentaReportEntity.dart';
import 'package:iventi/features/reports/entities/ProductoVendidoEntity.dart';
import 'package:iventi/features/reports/entities/LoteReportEntity.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteVentasRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProductosVendidosRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteLotesRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProximosVencerRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteInventarioGeneralRequest.dart';
import 'package:iventi/features/reports/services/ReportService.dart';

class ReportController {
  final ReportService _service;

  ReportController(this._service);

  Future<List<VentaReportEntity>> generarVentas(ReporteVentasRequest request) {
    return _service.generarReporteVentas(request);
  }

  Future<List<ProductoVendidoEntity>> generarProductosVendidos(
    ReporteProductosVendidosRequest request,
  ) {
    return _service.generarReporteProductosVendidos(request);
  }

  Future<List<LoteReportEntity>> generarLotes(ReporteLotesRequest request) {
    return _service.generarReporteLotes(request);
  }

  Future<List<LoteReportEntity>> generarProximosVencer(ReporteProximosVencerRequest request) {
    return _service.generarReporteProximosVencer(request);
  }

  Future<List<LoteReportEntity>> generarInventarioGeneral(
    ReporteInventarioGeneralRequest request,
  ) {
    return _service.generarReporteInventarioGeneral(request);
  }
}
