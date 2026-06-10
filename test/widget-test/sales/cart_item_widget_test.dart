import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/sales/widgets/CartItemWidget.dart';

void main() {
  group('CartItemWidget', () {
    group('renderizado', () {
      testWidgets('debe renderizar correctamente con datos del producto', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartItemWidget(
                nombre: 'Producto Test',
                precio: 25.50,
                cantidad: 3,
                subtotal: 76.50,
              ),
            ),
          ),
        );

        expect(find.byType(CartItemWidget), findsOneWidget);
        expect(find.text('Producto Test'), findsOneWidget);
        expect(find.text('Precio: S/ 25.50'), findsOneWidget);
        expect(find.text('Cantidad: 3'), findsOneWidget);
        expect(find.text('S/ 76.50'), findsOneWidget);
      });

      testWidgets('debe mostrar boton de eliminar cuando onDelete esta definido', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartItemWidget(
                nombre: 'Producto',
                precio: 10.00,
                cantidad: 1,
                subtotal: 10.00,
                onDelete: () {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('no debe mostrar boton de eliminar cuando onDelete es null', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartItemWidget(
                nombre: 'Producto',
                precio: 10.00,
                cantidad: 1,
                subtotal: 10.00,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.delete), findsNothing);
      });
    });

    group('interaccion', () {
      testWidgets('debe llamar a onDelete cuando se presiona el boton de eliminar', (WidgetTester tester) async {
        bool deleted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CartItemWidget(
                nombre: 'Producto',
                precio: 10.00,
                cantidad: 1,
                subtotal: 10.00,
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
  });
}