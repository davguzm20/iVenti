import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/sales/pages/SalesPage.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockVentaController mockController;

  setUp(() {
    mockController = MockVentaController();
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/sales',
      routes: [
        GoRoute(path: '/sales', builder: (_, __) => const SalesPage()),
        GoRoute(path: '/sales/create-sale', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/sales/details-sale/:id', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/sales/filter-sales', builder: (_, __) => const SizedBox()),
      ],
    );
    return MultiProvider(
      providers: [
        Provider<VentaController>.value(value: mockController),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('SalesPage', () {
    testWidgets('debe mostrar loading inicial', (tester) async {
      when(mockController.obtenerVentasFiltradas(
        limite: 50, offset: 0,
        esAlContado: anyNamed('esAlContado'),
        fechaInicio: anyNamed('fechaInicio'),
        fechaFinal: anyNamed('fechaFinal'),
      )).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe mostrar empty state cuando no hay ventas', (tester) async {
      when(mockController.obtenerVentasFiltradas(
        limite: 50, offset: 0,
        esAlContado: anyNamed('esAlContado'),
        fechaInicio: anyNamed('fechaInicio'),
        fechaFinal: anyNamed('fechaFinal'),
      )).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('No se encontraron ventas'), findsOneWidget);
    });

    testWidgets('debe mostrar lista de ventas', (tester) async {
      final venta = VentaEntity(
        idVenta: 1,
        idUsuario: 1,
        vendidoEn: DateTime(2025, 5, 1),
        montoTotal: 100.0,
        montoCancelado: 100.0,
        estado: EstadoVenta.COMPLETADA,
        esCredito: false,
        creadoEn: DateTime(2025, 5, 1),
      );

      when(mockController.obtenerVentasFiltradas(
        limite: 50, offset: 0,
        esAlContado: anyNamed('esAlContado'),
        fechaInicio: anyNamed('fechaInicio'),
        fechaFinal: anyNamed('fechaFinal'),
      )).thenAnswer((_) async => [venta]);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Venta 1'), findsOneWidget);
    });
  });
}
