import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/reports/widgets/ReportCard.dart';

void main() {
  group('ReportCard', () {
    group('renderizado', () {
      testWidgets('debe renderizar correctamente con titulo e icono', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ReportCard(
                title: 'Reporte de Ventas',
                icon: Icons.receipt_long,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.byType(ReportCard), findsOneWidget);
        expect(find.text('Reporte de Ventas'), findsOneWidget);
        expect(find.byIcon(Icons.receipt_long), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });

      testWidgets('debe mostrar subtitulo cuando se proporciona', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ReportCard(
                title: 'Reporte de Ventas',
                subtitle: 'Últimos 30 días',
                icon: Icons.receipt_long,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('Reporte de Ventas'), findsOneWidget);
        expect(find.text('Últimos 30 días'), findsOneWidget);
      });

      testWidgets('no debe mostrar subtitulo cuando es null', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ReportCard(
                title: 'Reporte de Ventas',
                icon: Icons.receipt_long,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('Reporte de Ventas'), findsOneWidget);
      });
    });

    group('interaccion', () {
      testWidgets('debe llamar a onTap cuando se presiona', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ReportCard(
                title: 'Reporte',
                icon: Icons.receipt,
                onTap: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ReportCard));
        await tester.pump();

        expect(tapped, isTrue);
      });
    });
  });
}