import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/reports/widgets/DateRangePicker.dart';

void main() {
  group('DateRangePickerWidget', () {
    group('renderizado', () {
      testWidgets('debe renderizar correctamente con fechas inicial y final', (WidgetTester tester) async {
        final startDate = DateTime(2026, 1, 1);
        final endDate = DateTime(2026, 1, 31);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DateRangePickerWidget(
                startDate: startDate,
                endDate: endDate,
                onStartDateChanged: (_) {},
                onEndDateChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(DateRangePickerWidget), findsOneWidget);
        expect(find.text('Inicio: 01/01/2026'), findsOneWidget);
        expect(find.text('Final: 31/01/2026'), findsOneWidget);
        expect(find.text('Seleccionar'), findsNWidgets(2));
      });

      testWidgets('debe renderizar con formato de fecha correcto', (WidgetTester tester) async {
        final startDate = DateTime(2024, 12, 5);
        final endDate = DateTime(2024, 12, 25);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DateRangePickerWidget(
                startDate: startDate,
                endDate: endDate,
                onStartDateChanged: (_) {},
                onEndDateChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Inicio: 05/12/2024'), findsOneWidget);
        expect(find.text('Final: 25/12/2024'), findsOneWidget);
      });
    });

    group('interaccion', () {
      testWidgets('debe tener botones Seleccionar habilitados', (WidgetTester tester) async {
        final startDate = DateTime(2026, 1, 1);
        final endDate = DateTime(2026, 1, 31);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DateRangePickerWidget(
                startDate: startDate,
                endDate: endDate,
                onStartDateChanged: (_) {},
                onEndDateChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Seleccionar'), findsNWidgets(2));
      });
    });
  });
}