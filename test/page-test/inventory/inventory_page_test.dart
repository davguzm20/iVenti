import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/inventory/pages/InventoryPage.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';

import '../module_setup.dart';

void main() {
  setUpAll(() {
    setupModuleMocks();
  });

  setUp(() {
    resetModuleMocks();
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/inventory',
      routes: [
        GoRoute(path: '/inventory', builder: (_, __) => const InventoryPage()),
        GoRoute(path: '/inventory/create-product', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/inventory/product/:id', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/inventory/filter-products', builder: (_, __) => const SizedBox()),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  group('InventoryPage', () {
    testWidgets('debe mostrar loading inicial', (tester) async {
      when(mockProductoController.obtenerTodos()).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe mostrar empty state cuando no hay productos', (tester) async {
      when(mockProductoController.obtenerTodos()).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('No se encontraron productos'), findsOneWidget);
    });

    testWidgets('debe mostrar lista de productos en grid', (tester) async {
      final producto = ProductoEntity(
        idProducto: 1,
        idUnidad: 1,
        nombre: 'Producto Test',
        precio: 25.50,
        stockActual: 10,
        stockMinimo: 5,
        creadoEn: DateTime(2025, 5, 1),
      );

      when(mockProductoController.obtenerTodos()).thenAnswer((_) async => [producto]);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Producto Test'), findsOneWidget);
    });
  });
}
