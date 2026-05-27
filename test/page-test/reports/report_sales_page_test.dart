import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/reports/pages/ReportSalesPage.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';

import '../../mocks_mocks.dart';
import '../helpers.dart';

void main() {
  late MockReportController mockController;

  setUp(() {
    mockController = MockReportController();
  });

  group('ReportSalesPage', () {
    testWidgets('debe mostrar titulo y selector de tipo', (tester) async {
      when(mockController.generarVentas(any)).thenAnswer((_) async => []);

      await pumpPage(
        tester,
        page: const ReportSalesPage(),
        providers: [
          Provider<ReportController>.value(value: mockController),
        ],
      );

      expect(find.text('Reporte de Ventas'), findsOneWidget);
      expect(find.text('Tipo de reporte'), findsOneWidget);
      expect(find.text('General'), findsOneWidget);
    });

    testWidgets('debe mostrar boton Generar', (tester) async {
      when(mockController.generarVentas(any)).thenAnswer((_) async => []);

      await pumpPage(
        tester,
        page: const ReportSalesPage(),
        providers: [
          Provider<ReportController>.value(value: mockController),
        ],
      );

      expect(find.text('Generar'), findsOneWidget);
    });
  });
}
