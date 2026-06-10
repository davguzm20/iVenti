import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteVentasRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProductosVendidosRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteLotesRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProximosVencerRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteInventarioGeneralRequest.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';

import '../../../mocks_mocks.dart';

final mockReportService = MockReportService();

ReportController buildController() => ReportController(mockReportService);

void main() {
  setUp(() {
    reset(mockReportService);
  });

  test('generarVentas delega a ReportService', () async {
    when(mockReportService.generarReporteVentas(any)).thenAnswer((_) async => []);

    final request = ReporteVentasRequest(
      fechaInicio: DateTime(2024, 1, 1), fechaFinal: DateTime(2024, 12, 31), tipo: 'todas',
    );
    final result = await buildController().generarVentas(request);

    expect(result, []);
    verify(mockReportService.generarReporteVentas(request)).called(1);
  });

  test('generarProductosVendidos delega a ReportService', () async {
    when(mockReportService.generarReporteProductosVendidos(any)).thenAnswer((_) async => []);

    final request = ReporteProductosVendidosRequest(
      fechaInicio: DateTime(2024, 1, 1), fechaFinal: DateTime(2024, 12, 31),
    );
    final result = await buildController().generarProductosVendidos(request);

    expect(result, []);
    verify(mockReportService.generarReporteProductosVendidos(request)).called(1);
  });

  test('generarLotes delega a ReportService', () async {
    when(mockReportService.generarReporteLotes(any)).thenAnswer((_) async => []);

    final request = ReporteLotesRequest(
      fechaInicio: DateTime(2024, 1, 1), fechaFinal: DateTime(2024, 12, 31), tipo: 'todos',
    );
    final result = await buildController().generarLotes(request);

    expect(result, []);
    verify(mockReportService.generarReporteLotes(request)).called(1);
  });

  test('generarProximosVencer delega a ReportService', () async {
    when(mockReportService.generarReporteProximosVencer(any)).thenAnswer((_) async => []);

    final request = ReporteProximosVencerRequest(dias: 30);
    final result = await buildController().generarProximosVencer(request);

    expect(result, []);
    verify(mockReportService.generarReporteProximosVencer(request)).called(1);
  });

  test('generarInventarioGeneral delega a ReportService', () async {
    when(mockReportService.generarReporteInventarioGeneral(any)).thenAnswer((_) async => []);

    final request = ReporteInventarioGeneralRequest(fecha: DateTime.now());
    final result = await buildController().generarInventarioGeneral(request);

    expect(result, []);
    verify(mockReportService.generarReporteInventarioGeneral(request)).called(1);
  });
}
