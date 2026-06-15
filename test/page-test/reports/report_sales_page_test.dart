import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/reports/pages/ReportSalesPage.dart';

import '../module_setup.dart';
import '../helpers.dart';

void main() {
  setUpAll(() {
    setupModuleMocks();
  });

  setUp(() {
    resetModuleMocks();
  });

  group('ReportSalesPage', () {
    testWidgets('debe mostrar titulo y selector de tipo', (tester) async {
      when(mockReportController.generarVentas(any)).thenAnswer((_) async => []);

      await pumpPage(
        tester,
        page: const ReportSalesPage(),
        providers: [],
      );

      expect(find.text('Reporte de Ventas'), findsOneWidget);
      expect(find.text('Tipo de reporte'), findsOneWidget);
      expect(find.text('General'), findsOneWidget);
    });

    testWidgets('debe mostrar boton Generar', (tester) async {
      when(mockReportController.generarVentas(any)).thenAnswer((_) async => []);

      await pumpPage(
        tester,
        page: const ReportSalesPage(),
        providers: [],
      );

      expect(find.text('Generar'), findsOneWidget);
    });
  });
}
