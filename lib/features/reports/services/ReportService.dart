import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/reports/entities/VentaReportEntity.dart';
import 'package:iventi/features/reports/entities/ProductoVendidoEntity.dart';
import 'package:iventi/features/reports/entities/LoteReportEntity.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteVentasRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProductosVendidosRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteLotesRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProximosVencerRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteInventarioGeneralRequest.dart';
import 'package:iventi/features/reports/mappers/VentaReportMapper.dart';
import 'package:iventi/features/reports/mappers/ProductoVendidoMapper.dart';
import 'package:iventi/features/reports/mappers/LoteReportMapper.dart';
import 'package:iventi/features/reports/repositories/IReportRepository.dart';

class ReportService {
  final IReportRepository _repository;

  ReportService(this._repository);

  Future<List<VentaReportEntity>> generarReporteVentas(ReporteVentasRequest request) async {
    try {
      final responses = await _repository.obtenerVentas(
        fechaInicio: request.fechaInicio,
        fechaFinal: request.fechaFinal,
        tipo: request.tipo,
      );
      return responses.map(VentaReportMapper.fromResponse).toList();
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de ventas: ${e.mensaje}');
    }
  }

  Future<List<ProductoVendidoEntity>> generarReporteProductosVendidos(
    ReporteProductosVendidosRequest request,
  ) async {
    try {
      final responses = await _repository.obtenerProductosVendidos(
        fechaInicio: request.fechaInicio,
        fechaFinal: request.fechaFinal,
      );
      return responses.map(ProductoVendidoMapper.fromResponse).toList();
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de productos vendidos: ${e.mensaje}');
    }
  }

  Future<List<LoteReportEntity>> generarReporteLotes(ReporteLotesRequest request) async {
    try {
      final responses = await _repository.obtenerLotes(
        fechaInicio: request.fechaInicio,
        fechaFinal: request.fechaFinal,
        tipo: request.tipo,
      );
      return responses.map(LoteReportMapper.fromResponse).toList();
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de lotes: ${e.mensaje}');
    }
  }

  Future<List<LoteReportEntity>> generarReporteProximosVencer(
    ReporteProximosVencerRequest request,
  ) async {
    try {
      final responses = await _repository.obtenerProximosVencer(request.dias);
      return responses.map(LoteReportMapper.fromResponse).toList();
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de próximos a vencer: ${e.mensaje}');
    }
  }

  Future<List<LoteReportEntity>> generarReporteInventarioGeneral(
    ReporteInventarioGeneralRequest request,
  ) async {
    try {
      final responses = await _repository.obtenerInventarioGeneral(request.fecha);
      return responses.map(LoteReportMapper.fromResponse).toList();
    } on DatabaseException catch (e) {
      throw BusinessException('Error al generar reporte de inventario general: ${e.mensaje}');
    }
  }
}
