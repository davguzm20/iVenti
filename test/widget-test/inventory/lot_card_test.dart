import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/inventory/widgets/LoteCard.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';

void main() {
  group('LoteCard', () {
    final now = DateTime.now();

    group('renderizado', () {
      testWidgets('debe renderizar lote vigente correctamente', (WidgetTester tester) async {
        final lote = LoteEntity(
          idLote: 1,
          idProducto: 1,
          fechaCompra: DateTime(now.year, 1, 1),
          fechaVencimiento: DateTime(now.year + 2, 1, 1),
          cantidadActual: 100,
          cantidadComprada: 200,
          cantidadPerdida: 0,
          precioCompra: 15.00,
          creadoEn: DateTime(now.year, 1, 1),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoteCard(lote: lote),
            ),
          ),
        );

        expect(find.byType(LoteCard), findsOneWidget);
        expect(find.text('Lote #1'), findsOneWidget);
        expect(find.text('Vigente'), findsOneWidget);
        expect(find.text('Cantidad: 100'), findsOneWidget);
        expect(find.text('S/ 15.00'), findsOneWidget);
      });

      testWidgets('debe mostrar estado Proximo a Vencer cuando faltan <= 30 dias', (WidgetTester tester) async {
        final fechaVencimiento = DateTime(now.year, now.month, now.day + 25);

        final lote = LoteEntity(
          idLote: 2,
          idProducto: 1,
          fechaCompra: DateTime(now.year, 1, 1),
          fechaVencimiento: fechaVencimiento,
          cantidadActual: 50,
          cantidadComprada: 100,
          cantidadPerdida: 0,
          precioCompra: 20.00,
          creadoEn: DateTime(now.year, 1, 1),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoteCard(lote: lote),
            ),
          ),
        );

        expect(find.text('Próximo a Vencer'), findsOneWidget);
        expect(find.textContaining('Vence en'), findsOneWidget);
      });

      testWidgets('debe mostrar estado Vencido cuando la fecha ya paso', (WidgetTester tester) async {
        final lote = LoteEntity(
          idLote: 3,
          idProducto: 1,
          fechaCompra: DateTime(now.year, 1, 1),
          fechaVencimiento: DateTime(now.year, now.month, now.day - 5),
          cantidadActual: 0,
          cantidadComprada: 50,
          cantidadPerdida: 50,
          precioCompra: 10.00,
          creadoEn: DateTime(now.year, 1, 1),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoteCard(lote: lote),
            ),
          ),
        );

        expect(find.text('Vencido'), findsOneWidget);
        expect(find.textContaining('Venció hace'), findsOneWidget);
      });
    });

    group('interaccion', () {
      final lote = LoteEntity(
        idLote: 1,
        idProducto: 1,
        fechaCompra: DateTime(now.year, 1, 1),
        fechaVencimiento: DateTime(now.year + 2, 1, 1),
        cantidadActual: 100,
        cantidadComprada: 200,
        cantidadPerdida: 0,
        precioCompra: 15.00,
        creadoEn: DateTime(now.year, 1, 1),
      );

      testWidgets('debe llamar a onTap cuando se presiona la card', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoteCard(
                lote: lote,
                onTap: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(LoteCard));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('debe llamar a onEdit cuando se presiona el boton de editar', (WidgetTester tester) async {
        bool edited = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoteCard(
                lote: lote,
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
              body: LoteCard(
                lote: lote,
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
      final lote = LoteEntity(
        idLote: 1,
        idProducto: 1,
        fechaCompra: DateTime(now.year, 1, 1),
        fechaVencimiento: DateTime(now.year + 2, 1, 1),
        cantidadActual: 100,
        cantidadComprada: 200,
        cantidadPerdida: 0,
        precioCompra: 15.00,
        creadoEn: DateTime(now.year, 1, 1),
      );

      testWidgets('debe mostrar botones de acciones cuando los callbacks estan definidos', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoteCard(
                lote: lote,
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
              body: LoteCard(lote: lote),
            ),
          ),
        );

        expect(find.byIcon(Icons.edit), findsNothing);
        expect(find.byIcon(Icons.delete), findsNothing);
      });
    });
  });
}