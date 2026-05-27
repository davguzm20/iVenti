import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/inventory/pages/CreateProductPage.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';
import 'package:iventi/features/inventory/controllers/CategoriaController.dart';
import 'package:iventi/features/inventory/controllers/UnidadController.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockProductoController mockProductoController;
  late MockCategoriaController mockCategoriaController;
  late MockUnidadController mockUnidadController;

  setUp(() {
    mockProductoController = MockProductoController();
    mockCategoriaController = MockCategoriaController();
    mockUnidadController = MockUnidadController();
  });

  Widget _buildTestApp() {
    final router = GoRouter(
      initialLocation: '/inventory/create-product',
      routes: [
        GoRoute(path: '/inventory/create-product', builder: (_, __) => const CreateProductPage()),
        GoRoute(path: '/image-picker', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/barcode-scanner', builder: (_, __) => const SizedBox()),
      ],
    );
    return MultiProvider(
      providers: [
        Provider<ProductoController>.value(value: mockProductoController),
        Provider<CategoriaController>.value(value: mockCategoriaController),
        Provider<UnidadController>.value(value: mockUnidadController),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('CreateProductPage', () {
    testWidgets('debe mostrar formulario de creacion', (tester) async {
      when(mockCategoriaController.obtenerTodas()).thenAnswer((_) async => []);
      when(mockUnidadController.obtenerTodas()).thenAnswer((_) async => []);

      await tester.pumpWidget(_buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Crear Producto'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
    });

    testWidgets('debe mostrar categorias y unidades disponibles', (tester) async {
      when(mockCategoriaController.obtenerTodas()).thenAnswer((_) async => [
        CategoriaEntity(idCategoria: 1, nombre: 'Lácteos', creadoEn: DateTime(2025, 5, 1)),
        CategoriaEntity(idCategoria: 2, nombre: 'Bebidas', creadoEn: DateTime(2025, 5, 1)),
      ]);
      when(mockUnidadController.obtenerTodas()).thenAnswer((_) async => [
        UnidadEntity(idUnidad: 1, nombre: 'Kilogramo', abreviatura: 'kg', creadoEn: DateTime(2025, 5, 1)),
      ]);

      await tester.pumpWidget(_buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Lácteos'), findsOneWidget);
      expect(find.text('Bebidas'), findsOneWidget);
      expect(find.text('Agregar categoría'), findsOneWidget);
    });
  });
}
