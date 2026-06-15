import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/inventory/pages/ProductPage.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';

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
      initialLocation: '/inventory/product/1',
      routes: [
        GoRoute(path: '/inventory/product/1', builder: (_, __) => const ProductPage(idProducto: 1)),
        GoRoute(path: '/image-picker', builder: (_, __) => const SizedBox()),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  group('ProductPage', () {
    testWidgets('debe mostrar loading inicial', (tester) async {
      when(mockProductoController.obtenerProductoPorId(1))
          .thenAnswer((_) async => null);

      await tester.pumpWidget(buildTestApp());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe mostrar datos del producto cuando se carga', (tester) async {
      final producto = ProductoEntity(
        idProducto: 1,
        idUnidad: 1,
        nombre: 'Producto Test',
        precio: 25.50,
        stockActual: 10,
        stockMinimo: 5,
        creadoEn: DateTime(2025, 5, 1),
      );
      final unidad = UnidadEntity(idUnidad: 1, nombre: 'Kilogramo', abreviatura: 'kg', creadoEn: DateTime(2025, 5, 1));

      when(mockProductoController.obtenerProductoPorId(1))
          .thenAnswer((_) async => producto);
      when(mockCategoriaController.obtenerDeProducto(1))
          .thenAnswer((_) async => []);
      when(mockUnidadController.obtenerTodas())
          .thenAnswer((_) async => [unidad]);
      when(mockLoteController.obtenerLotesDeProducto(1))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Producto Test'), findsOneWidget);
      expect(find.text('Precio: S/ 25.50'), findsOneWidget);
    });

    testWidgets('debe mostrar lotes y categorias', (tester) async {
      final producto = ProductoEntity(
        idProducto: 1,
        idUnidad: 1,
        nombre: 'Producto Test',
        precio: 25.50,
        stockActual: 10,
        stockMinimo: 5,
        creadoEn: DateTime(2025, 5, 1),
      );
      final unidad = UnidadEntity(idUnidad: 1, nombre: 'Kilogramo', abreviatura: 'kg', creadoEn: DateTime(2025, 5, 1));
      final categoria = CategoriaEntity(idCategoria: 1, nombre: 'Lácteos', creadoEn: DateTime(2025, 5, 1));
      final lote = LoteEntity(
        idLote: 1,
        idProducto: 1,
        fechaCompra: DateTime(2025, 5, 1),
        fechaVencimiento: DateTime(2025, 6, 1),
        cantidadActual: 5,
        cantidadComprada: 10,
        cantidadPerdida: 0,
        precioCompra: 15.0,
        creadoEn: DateTime(2025, 5, 1),
      );

      when(mockProductoController.obtenerProductoPorId(1))
          .thenAnswer((_) async => producto);
      when(mockCategoriaController.obtenerDeProducto(1))
          .thenAnswer((_) async => [categoria]);
      when(mockUnidadController.obtenerTodas())
          .thenAnswer((_) async => [unidad]);
      when(mockLoteController.obtenerLotesDeProducto(1))
          .thenAnswer((_) async => [lote]);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Lácteos'), findsOneWidget);
    });
  });
}
