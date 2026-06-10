import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/sales/widgets/CartWidget.dart';

void main() {
  group('CartWidget', () {
    final testItems = [
      {
        'nombre': 'Producto 1',
        'precio': 25.0,
        'cantidad': 2,
        'subtotalProducto': 50.0,
      },
      {
        'nombre': 'Producto 2',
        'precio': 15.0,
        'cantidad': 1,
        'subtotalProducto': 15.0,
      },
    ];

    group('renderizado', () {
      testWidgets('debe mostrar mensaje cuando la lista esta vacia', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartWidget(
                items: [],
                total: 0.0,
                onDeleteItem: (_) {},
                onConfirm: () {},
              ),
            ),
          ),
        );

        expect(find.text('No hay productos agregados'), findsOneWidget);
      });

      testWidgets('debe mostrar items del carrito', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartWidget(
                items: testItems,
                total: 65.0,
                onDeleteItem: (_) {},
                onConfirm: () {},
              ),
            ),
          ),
        );

        expect(find.byType(CartWidget), findsOneWidget);
        expect(find.text('Producto 1'), findsOneWidget);
        expect(find.text('Producto 2'), findsOneWidget);
      });

      testWidgets('debe mostrar el total correctamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartWidget(
                items: testItems,
                total: 65.0,
                onDeleteItem: (_) {},
                onConfirm: () {},
              ),
            ),
          ),
        );

        expect(find.text('Total: '), findsOneWidget);
        expect(find.text('65.00'), findsOneWidget);
      });

      testWidgets('debe mostrar boton Confirmar', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartWidget(
                items: testItems,
                total: 65.0,
                onDeleteItem: (_) {},
                onConfirm: () {},
              ),
            ),
          ),
        );

        expect(find.text('Confirmar'), findsOneWidget);
      });

      testWidgets('debe mostrar boton Agregar producto cuando onAddProduct esta definido', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartWidget(
                items: testItems,
                total: 65.0,
                onDeleteItem: (_) {},
                onConfirm: () {},
                onAddProduct: () {},
              ),
            ),
          ),
        );

        expect(find.text('Agregar producto'), findsOneWidget);
      });

      testWidgets('no debe mostrar boton Agregar producto cuando onAddProduct es null', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartWidget(
                items: testItems,
                total: 65.0,
                onDeleteItem: (_) {},
                onConfirm: () {},
              ),
            ),
          ),
        );

        expect(find.text('Agregar producto'), findsNothing);
      });
    });

    group('interaccion', () {
      testWidgets('debe llamar a onConfirm cuando se presiona el boton Confirmar', (WidgetTester tester) async {
        bool confirmed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartWidget(
                items: testItems,
                total: 65.0,
                onDeleteItem: (_) {},
                onConfirm: () => confirmed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Confirmar'));
        await tester.pump();

        expect(confirmed, isTrue);
      });

      testWidgets('debe llamar a onDeleteItem con el indice correcto', (WidgetTester tester) async {
        int? deletedIndex;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartWidget(
                items: testItems,
                total: 65.0,
                onDeleteItem: (index) => deletedIndex = index,
                onConfirm: () {},
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.delete).first);
        await tester.pump();

        expect(deletedIndex, 0);
      });
    });
  });
}