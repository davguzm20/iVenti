import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/sales/widgets/SaleCard.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';

void main() {
  group('SaleCard', () {
    final now = DateTime.now();

    VentaEntity createVenta({
      int id = 1,
      double montoTotal = 100.0,
      double montoCancelado = 100.0,
      bool esCredito = false,
    }) {
      return VentaEntity(
        idVenta: id,
        idUsuario: 1,
        vendidoEn: now,
        montoTotal: montoTotal,
        montoCancelado: montoCancelado,
        estado: EstadoVenta.COMPLETADA,
        esCredito: esCredito,
        creadoEn: now,
      );
    }

    group('renderizado', () {
      testWidgets('debe renderizar venta al contado correctamente', (WidgetTester tester) async {
        final venta = createVenta();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SaleCard(
                venta: venta,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.byType(SaleCard), findsOneWidget);
        expect(find.text('Venta 1'), findsOneWidget);
        expect(find.textContaining('Monto: S/'), findsOneWidget);
        expect(find.textContaining('Al contado'), findsOneWidget);
      });

      testWidgets('debe renderizar venta a credito no cancelada', (WidgetTester tester) async {
        final venta = createVenta(esCredito: true, montoCancelado: 50.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SaleCard(
                venta: venta,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.textContaining('Crédito'), findsOneWidget);
      });

      testWidgets('debe renderizar venta a credito cancelada', (WidgetTester tester) async {
        final venta = createVenta(esCredito: true, montoCancelado: 100.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SaleCard(
                venta: venta,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.textContaining('Crédito (Cancelado)'), findsOneWidget);
      });

      testWidgets('debe mostrar boton Detalles cuando onDetails esta definido', (WidgetTester tester) async {
        final venta = createVenta();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SaleCard(
                venta: venta,
                onTap: () {},
                onDetails: () {},
              ),
            ),
          ),
        );

        expect(find.text('Detalles'), findsOneWidget);
      });

      testWidgets('no debe mostrar boton Detalles cuando onDetails es null', (WidgetTester tester) async {
        final venta = createVenta();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SaleCard(
                venta: venta,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('Detalles'), findsNothing);
      });
    });

    group('interaccion', () {
      testWidgets('debe llamar a onTap cuando se presiona la card', (WidgetTester tester) async {
        bool tapped = false;
        final venta = createVenta();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SaleCard(
                venta: venta,
                onTap: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(SaleCard));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('debe llamar a onDetails cuando se presiona el boton Detalles', (WidgetTester tester) async {
        bool details = false;
        final venta = createVenta();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SaleCard(
                venta: venta,
                onTap: () {},
                onDetails: () => details = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Detalles'));
        await tester.pump();

        expect(details, isTrue);
      });
    });
  });
}