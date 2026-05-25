import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/shared/widgets/SuccessButton.dart';

void main() {
  group('SuccessButton', () {
    testWidgets('debe renderizar correctamente con texto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuccessButton(text: 'Éxito'),
          ),
        ),
      );

      expect(find.text('Éxito'), findsOneWidget);
    });

    testWidgets('debe mostrar icono cuando se proporciona', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuccessButton(
              text: 'Éxito',
              icon: Icons.check,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Éxito'), findsOneWidget);
    });

    testWidgets('debe mostrar CircularProgressIndicator cuando isLoading es true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuccessButton(
              text: 'Cargando',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
