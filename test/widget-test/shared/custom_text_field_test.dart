import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';

void main() {
  group('CustomTextField', () {
    testWidgets('debe renderizar correctamente con label', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Nombre',
              controller: controller,
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      );

      expect(find.text('Nombre'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('debe mostrar sufijo cuando se proporciona', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Precio',
              controller: controller,
              keyboardType: TextInputType.number,
              suffixIcon: Icon(Icons.attach_money),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });

    testWidgets('debe mostrar asterisco cuando isRequired es true', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Nombre',
              controller: controller,
              keyboardType: TextInputType.text,
              isRequired: true,
            ),
          ),
        ),
      );

      expect(find.text('Nombre *'), findsOneWidget);
    });
  });
}
