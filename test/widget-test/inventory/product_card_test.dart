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
        expect(find.text('Código: PROD001'), findsOneWidget);
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

      testWidgets('no debe mostrar codigo cuando es null', (WidgetTester tester) async {
        final productWithoutCode = ProductoEntity(
          idProducto: 3,
          idUnidad: 1,
          codigo: null,
          nombre: 'Sin Codigo',
          precio: 15.00,
          stockActual: 20,
          stockMinimo: 5,
          creadoEn: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: productWithoutCode,
              ),
            ),
          ),
        );

        expect(find.text('Código: '), findsNothing);
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

      testWidgets('debe llamar a onEdit cuando se presiona el boton de editar', (WidgetTester tester) async {
        bool edited = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testProduct,
                onEdit: () => edited = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.edit));
        await tester.pump();

        expect(edited, isTrue);
      });

      testWidgets('debe llamar a onDelete cuando se presiona el boton de eliminar', (WidgetTester tester) async {
        bool deleted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testProduct,
                onDelete: () => deleted = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pump();

        expect(deleted, isTrue);
      });
    });

    group('estados', () {
      testWidgets('debe mostrar botones de acciones cuando los callbacks estan definidos', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testProduct,
                onEdit: () {},
                onDelete: () {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('no debe mostrar botones de acciones cuando los callbacks son null', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testProduct,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.edit), findsNothing);
        expect(find.byIcon(Icons.delete), findsNothing);
      });
    });
  });
}