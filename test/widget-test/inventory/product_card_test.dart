import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/inventory/widgets/ProductCard.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';

void main() {
  group('ProductCard', () {
    final testProduct = ProductoEntity(
      idProducto: 1,
      idUnidad: 1,
      codigo: 'PROD001',
      nombre: 'Producto Test',
      precio: 25.50,
      stockActual: 50,
      stockMinimo: 10,
      creadoEn: DateTime.now(),
    );

    group('renderizado', () {
      testWidgets('debe renderizar correctamente con producto completo', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testProduct,
              ),
            ),
          ),
        );

        expect(find.byType(ProductCard), findsOneWidget);
        expect(find.text('Producto Test'), findsOneWidget);
        expect(find.text('S/ 25.50'), findsOneWidget);
        expect(find.text('Stock: 50'), findsOneWidget);
      });

      testWidgets('debe mostrar etiqueta Stock Bajo cuando stockActual <= stockMinimo', (WidgetTester tester) async {
        final lowStockProduct = ProductoEntity(
          idProducto: 2,
          idUnidad: 1,
          codigo: 'PROD002',
          nombre: 'Producto Bajo',
          precio: 10.00,
          stockActual: 5,
          stockMinimo: 10,
          creadoEn: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: lowStockProduct,
              ),
            ),
          ),
        );

        expect(find.text('Stock Bajo'), findsOneWidget);
        expect(find.text('Stock: 5'), findsOneWidget);
      });

      testWidgets('no debe mostrar etiqueta Stock Bajo cuando stockActual > stockMinimo', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testProduct,
              ),
            ),
          ),
        );

        expect(find.text('Stock Bajo'), findsNothing);
      });
    });

    group('interaccion', () {
      testWidgets('debe llamar a onTap cuando se presiona la card', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testProduct,
                onTap: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ProductCard));
        await tester.pump();

        expect(tapped, isTrue);
      });
    });
  });
}
