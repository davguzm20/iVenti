import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/reports/entities/VentaReportEntity.dart';
import 'package:iventi/features/reports/entities/ProductoVendidoEntity.dart';
import 'package:iventi/features/reports/entities/LoteReportEntity.dart';
import 'package:iventi/features/reports/repositories/ReportRepository.dart';

class ReportService {
  final ReportRepository _repository;

  ReportService(this._repository);

  Future<List<VentaReportEntity>> generarReporteVentas({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
    String? tipo,
  }) async {
    _validarFechas(fechaInicio, fechaFinal);

    try {
      return await _repository.obtenerVentas(
        fechaInicio: fechaInicio,
        fechaFinal: fechaFinal,
        tipo: tipo,
      );
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de ventas: ${e.mensaje}');
    }
  }

  Future<List<ProductoVendidoEntity>> generarReporteProductosVendidos({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
  }) async {
    _validarFechas(fechaInicio, fechaFinal);

    try {
      return await _repository.obtenerProductosVendidos(
        fechaInicio: fechaInicio,
        fechaFinal: fechaFinal,
      );
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de productos vendidos: ${e.mensaje}');
    }
  }

  Future<List<LoteReportEntity>> generarReporteLotes({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
    String? tipo,
  }) async {
    _validarFechas(fechaInicio, fechaFinal);

    try {
      return await _repository.obtenerLotes(
        fechaInicio: fechaInicio,
        fechaFinal: fechaFinal,
        tipo: tipo,
      );
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de lotes: ${e.mensaje}');
    }
  }

  Future<List<LoteReportEntity>> generarReporteProximosVencer(int dias) async {
    if (dias <= 0) {
      throw BusinessException('El número de días debe ser mayor a 0');
    }

    try {
      return await _repository.obtenerProximosVencer(dias);
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de próximos a vencer: ${e.mensaje}');
    }
  }

  Future<List<LoteReportEntity>> generarReporteInventarioGeneral(DateTime fecha) async {
    try {
      return await _repository.obtenerInventarioGeneral(fecha);
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de inventario general: ${e.mensaje}');
    }
  }

  void _validarFechas(DateTime inicio, DateTime fin) {
    if (inicio.isAfter(fin)) {
      throw BusinessException('La fecha de inicio no puede ser posterior a la fecha final');
    }
  }
}
