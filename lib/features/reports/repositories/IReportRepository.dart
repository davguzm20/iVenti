import 'package:iventi/features/reports/dtos/responses/VentaReportResponse.dart';
import 'package:iventi/features/reports/dtos/responses/ProductoVendidoResponse.dart';
import 'package:iventi/features/reports/dtos/responses/LoteReportResponse.dart';

abstract class IReportRepository {
  Future<List<VentaReportResponse>> obtenerVentas({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
    String? tipo,
  });
  Future<List<ProductoVendidoResponse>> obtenerProductosVendidos({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
  });
  Future<List<LoteReportResponse>> obtenerLotes({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
    String? tipo,
  });
  Future<List<LoteReportResponse>> obtenerProximosVencer(int dias);
  Future<List<LoteReportResponse>> obtenerInventarioGeneral(DateTime fecha);
}
