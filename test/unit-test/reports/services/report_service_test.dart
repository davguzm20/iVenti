import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/reports/services/ReportService.dart';
import 'package:iventi/features/reports/repositories/IReportRepository.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteVentasRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProductosVendidosRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteLotesRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProximosVencerRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteInventarioGeneralRequest.dart';

import '../../../mocks_mocks.dart';

final mockRepository = MockIReportRepository();

ReportService buildService() => ReportService(mockRepository);

void main() {
  setUp(() {
    reset(mockRepository);
  });

  group('ReportService.generarReporteVentas', () {
    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = ReporteVentasRequest(
        fechaInicio: DateTime.now().subtract(Duration(days: 30)),
        fechaFinal: DateTime.now(),
        tipo: 'todas',
      );

      when(mockRepository.obtenerVentas(
        fechaInicio: anyNamed('fechaInicio'),
        fechaFinal: anyNamed('fechaFinal'),
        tipo: anyNamed('tipo'),
      )).thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().generarReporteVentas(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar reporte de ventas'))),
      );
    });
  });

  group('ReportService.generarReporteProductosVendidos', () {
    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = ReporteProductosVendidosRequest(
        fechaInicio: DateTime.now().subtract(Duration(days: 30)),
        fechaFinal: DateTime.now(),
      );

      when(mockRepository.obtenerProductosVendidos(
        fechaInicio: anyNamed('fechaInicio'),
        fechaFinal: anyNamed('fechaFinal'),
      )).thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().generarReporteProductosVendidos(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar reporte de productos vendidos'))),
      );
    });
  });

  group('ReportService.generarReporteLotes', () {
    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = ReporteLotesRequest(
        fechaInicio: DateTime.now().subtract(Duration(days: 30)),
        fechaFinal: DateTime.now(),
        tipo: 'todos',
      );

      when(mockRepository.obtenerLotes(
        fechaInicio: anyNamed('fechaInicio'),
        fechaFinal: anyNamed('fechaFinal'),
        tipo: anyNamed('tipo'),
      )).thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().generarReporteLotes(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar reporte de lotes'))),
      );
    });
  });

  group('ReportService.generarReporteProximosVencer', () {
    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = ReporteProximosVencerRequest(dias: 30);

      when(mockRepository.obtenerProximosVencer(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().generarReporteProximosVencer(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar reporte de próximos a vencer'))),
      );
    });
  });

  group('ReportService.generarReporteInventarioGeneral', () {
    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = ReporteInventarioGeneralRequest(fecha: DateTime.now());

      when(mockRepository.obtenerInventarioGeneral(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().generarReporteInventarioGeneral(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar reporte de inventario general'))),
      );
    });
  });
}
