import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/reports/services/ReportService.dart';
import 'package:iventi/features/reports/repositories/ReportRepository.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteVentasRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProductosVendidosRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteLotesRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProximosVencerRequest.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteInventarioGeneralRequest.dart';

void main() {
  late PostgresDatasource datasource;
  late ReportService service;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    datasource = PostgresDatasource();
    final repository = ReportRepository(datasource);
    service = ReportService(repository);
  });

  group('ReportService con BD real', () {
    test('generarReporteVentas debe devolver lista en rango de fechas [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await service.generarReporteVentas(ReporteVentasRequest(
        fechaInicio: DateTime(2023, 1, 1),
        fechaFinal: DateTime(2030, 12, 31),
      ));

      expect(resultado, isA<List>());
    });

    test('generarReporteProductosVendidos debe devolver lista en rango de fechas [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await service.generarReporteProductosVendidos(ReporteProductosVendidosRequest(
        fechaInicio: DateTime(2023, 1, 1),
        fechaFinal: DateTime(2030, 12, 31),
      ));

      expect(resultado, isA<List>());
    });

    test('generarReporteLotes debe devolver lista en rango de fechas [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await service.generarReporteLotes(ReporteLotesRequest(
        fechaInicio: DateTime(2023, 1, 1),
        fechaFinal: DateTime(2030, 12, 31),
      ));

      expect(resultado, isA<List>());
    });

    test('generarReporteProximosVencer debe devolver lista [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await service.generarReporteProximosVencer(ReporteProximosVencerRequest(dias: 365));

      expect(resultado, isA<List>());
    });

    test('generarReporteInventarioGeneral debe devolver lista [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await service.generarReporteInventarioGeneral(ReporteInventarioGeneralRequest(
        fecha: DateTime(2030, 12, 31),
      ));

      expect(resultado, isA<List>());
    });

    test('debe lanzar ValidationException con fechas invalidas [en BD real]', () async {
      expect(
        () => ReporteVentasRequest(
          fechaInicio: DateTime(2030, 1, 1),
          fechaFinal: DateTime(2023, 1, 1),
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
