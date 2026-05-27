import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/reports/pages/ReportsPage.dart';

void main() {
  Widget _buildTestApp() {
    final router = GoRouter(
      initialLocation: '/reports',
      routes: [
        GoRoute(path: '/reports', builder: (_, __) => const ReportsPage()),
        GoRoute(path: '/reports/ventas', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/reports/productos-vendidos', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/reports/inventario', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/reports/lotes', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/reports/vencimientos', builder: (_, __) => const SizedBox()),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  group('ReportsPage', () {
    testWidgets('debe mostrar titulo y todos los reportes', (tester) async {
      await tester.pumpWidget(_buildTestApp());

      expect(find.text('Mis Reportes'), findsOneWidget);
      expect(find.text('Reporte Detallado de Ventas'), findsOneWidget);
      expect(find.text('Productos Vendidos'), findsOneWidget);
      expect(find.text('Inventario General'), findsOneWidget);
      expect(find.text('Lotes'), findsOneWidget);
      expect(find.text('Próximos a Vencer'), findsOneWidget);
    });
  });
}
