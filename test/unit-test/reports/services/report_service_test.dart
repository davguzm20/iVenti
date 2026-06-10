import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/reports/services/ReportService.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteVentasRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProductosVendidosRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteLotesRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProximosVencerRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteInventarioGeneralRequest.dart';
import 'package:iventi/features/reports/dtos/responses/VentaReportResponse.dart';
import 'package:iventi/features/reports/dtos/responses/ProductoVendidoResponse.dart';
import 'package:iventi/features/reports/dtos/responses/LoteReportResponse.dart';
import 'package:iventi/features/reports/entities/VentaReportEntity.dart';
import 'package:iventi/features/reports/entities/ProductoVendidoEntity.dart';
import 'package:iventi/features/reports/entities/LoteReportEntity.dart';

import '../../../mocks_mocks.dart';

final mockRepository = MockIReportRepository();

ReportService buildService() => ReportService(mockRepository);

void main() {
  setUp(() {
    reset(mockRepository);
  });

  group('ReportService.generarReporteVentas', () {
    test('debe generar reporte de ventas correctamente', () async {
      final responses = [
        VentaReportResponse(idVenta: 1, codigoBoleta: 'B001', cliente: 'Cliente', fecha: DateTime.now(), montoTotal: 100, montoCancelado: 100, tipo: 'contado'),
      ];
      when(mockRepository.obtenerVentas(
        fechaInicio: anyNamed('fechaInicio'), fechaFinal: anyNamed('fechaFinal'), tipo: anyNamed('tipo'),
      )).thenAnswer((_) async => responses);

      final request = ReporteVentasRequest(fechaInicio: DateTime.now().subtract(Duration(days: 30)), fechaFinal: DateTime.now(), tipo: 'todas');
      final result = await buildService().generarReporteVentas(request);

      expect(result.length, 1);
      expect(result.first, isA<VentaReportEntity>());
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = ReporteVentasRequest(
        fechaInicio: DateTime.now().subtract(Duration(days: 30)), fechaFinal: DateTime.now(), tipo: 'todas',
      );

      when(mockRepository.obtenerVentas(
        fechaInicio: anyNamed('fechaInicio'), fechaFinal: anyNamed('fechaFinal'), tipo: anyNamed('tipo'),
      )).thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().generarReporteVentas(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar reporte de ventas'))),
      );
    });
  });

  group('ReportService.generarReporteProductosVendidos', () {
    test('debe generar reporte de productos vendidos correctamente', () async {
      final responses = [
        ProductoVendidoResponse(producto: 'Producto', cantidad: 5, precioUnitario: 10, subtotal: 50),
      ];
      when(mockRepository.obtenerProductosVendidos(
        fechaInicio: anyNamed('fechaInicio'), fechaFinal: anyNamed('fechaFinal'),
      )).thenAnswer((_) async => responses);

      final request = ReporteProductosVendidosRequest(fechaInicio: DateTime.now().subtract(Duration(days: 30)), fechaFinal: DateTime.now());
      final result = await buildService().generarReporteProductosVendidos(request);

      expect(result.length, 1);
      expect(result.first, isA<ProductoVendidoEntity>());
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = ReporteProductosVendidosRequest(
        fechaInicio: DateTime.now().subtract(Duration(days: 30)), fechaFinal: DateTime.now(),
      );

      when(mockRepository.obtenerProductosVendidos(
        fechaInicio: anyNamed('fechaInicio'), fechaFinal: anyNamed('fechaFinal'),
      )).thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().generarReporteProductosVendidos(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar reporte de productos vendidos'))),
      );
    });
  });

  group('ReportService.generarReporteLotes', () {
    test('debe generar reporte de lotes correctamente', () async {
      final responses = [
        LoteReportResponse(idLote: 1, producto: 'Producto', cantidadActual: 10, cantidadComprada: 100, fechaVencimiento: DateTime.now()),
      ];
      when(mockRepository.obtenerLotes(
        fechaInicio: anyNamed('fechaInicio'), fechaFinal: anyNamed('fechaFinal'), tipo: anyNamed('tipo'),
      )).thenAnswer((_) async => responses);

      final request = ReporteLotesRequest(fechaInicio: DateTime.now().subtract(Duration(days: 30)), fechaFinal: DateTime.now(), tipo: 'todos');
      final result = await buildService().generarReporteLotes(request);

      expect(result.length, 1);
      expect(result.first, isA<LoteReportEntity>());
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = ReporteLotesRequest(
        fechaInicio: DateTime.now().subtract(Duration(days: 30)), fechaFinal: DateTime.now(), tipo: 'todos',
      );

      when(mockRepository.obtenerLotes(
        fechaInicio: anyNamed('fechaInicio'), fechaFinal: anyNamed('fechaFinal'), tipo: anyNamed('tipo'),
      )).thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().generarReporteLotes(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar reporte de lotes'))),
      );
    });
  });

  group('ReportService.generarReporteProximosVencer', () {
    test('debe generar reporte de proximos a vencer correctamente', () async {
      final responses = [
        LoteReportResponse(idLote: 1, producto: 'Producto', cantidadActual: 10, cantidadComprada: 100, fechaVencimiento: DateTime.now()),
      ];
      when(mockRepository.obtenerProximosVencer(any)).thenAnswer((_) async => responses);

      final request = ReporteProximosVencerRequest(dias: 30);
      final result = await buildService().generarReporteProximosVencer(request);

      expect(result.length, 1);
      expect(result.first, isA<LoteReportEntity>());
    });

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
    test('debe generar reporte de inventario general correctamente', () async {
      final responses = [
        LoteReportResponse(idLote: 1, producto: 'Producto', cantidadActual: 10, cantidadComprada: 100, fechaVencimiento: DateTime.now()),
      ];
      when(mockRepository.obtenerInventarioGeneral(any)).thenAnswer((_) async => responses);

      final request = ReporteInventarioGeneralRequest(fecha: DateTime.now());
      final result = await buildService().generarReporteInventarioGeneral(request);

      expect(result.length, 1);
      expect(result.first, isA<LoteReportEntity>());
    });

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
