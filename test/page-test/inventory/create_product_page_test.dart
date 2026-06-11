import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/inventory/pages/CreateProductPage.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/shared/di/modules/inventory_module.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockProductoController mockProductoController;
  late MockCategoriaController mockCategoriaController;
  late MockUnidadController mockUnidadController;

  setUpAll(() {
    mockProductoController = MockProductoController();
    mockCategoriaController = MockCategoriaController();
    mockUnidadController = MockUnidadController();
    InventoryModule.productoController = mockProductoController;
    InventoryModule.categoriaController = mockCategoriaController;
    InventoryModule.unidadController = mockUnidadController;
  });

  setUp(() {
    reset(mockProductoController);
    reset(mockCategoriaController);
    reset(mockUnidadController);
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/inventory/create-product',
      routes: [
        GoRoute(path: '/inventory/create-product', builder: (_, __) => const CreateProductPage()),
        GoRoute(path: '/image-picker', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/barcode-scanner', builder: (_, __) => const SizedBox()),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  group('CreateProductPage', () {
    testWidgets('debe mostrar formulario de creacion', (tester) async {
      when(mockCategoriaController.obtenerTodas()).thenAnswer((_) async => []);
      when(mockUnidadController.obtenerTodas()).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Crear Producto'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
    });

    testWidgets('debe mostrar categorias y unidades disponibles', (tester) async {
      when(mockCategoriaController.obtenerTodas()).thenAnswer((_) async => [
        CategoriaEntity(idCategoria: 1, nombre: 'Lacteos', creadoEn: DateTime(2025, 5, 1)),
        CategoriaEntity(idCategoria: 2, nombre: 'Bebidas', creadoEn: DateTime(2025, 5, 1)),
      ]);
      when(mockUnidadController.obtenerTodas()).thenAnswer((_) async => [
        UnidadEntity(idUnidad: 1, nombre: 'Kilogramo', abreviatura: 'kg', creadoEn: DateTime(2025, 5, 1)),
      ]);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Lacteos'), findsOneWidget);
      expect(find.text('Bebidas'), findsOneWidget);
      expect(find.text('Agregar categoria'), findsOneWidget);
    });
  });
}
