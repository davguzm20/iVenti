import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/shared/widgets/PrimaryButton.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('debe renderizar correctamente con texto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Guardar'),
          ),
        ),
      );

      expect(find.text('Guardar'), findsOneWidget);
    });

    testWidgets('debe mostrar icono cuando se proporciona', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Guardar',
              icon: Icons.save,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.text('Guardar'), findsOneWidget);
    });

    testWidgets('debe mostrar CircularProgressIndicator cuando isLoading es true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
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
