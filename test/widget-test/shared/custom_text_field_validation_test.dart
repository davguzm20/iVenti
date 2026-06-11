import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';

void main() {
  testWidgets('CustomTextField con label basico', (tester) async {
    final controller = TextEditingController();
    addTearDown(() => controller.dispose());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            label: 'DNI requerido',
            controller: controller,
            keyboardType: TextInputType.text,
          ),
        ),
      ),
    );

    expect(find.text('DNI requerido'), findsOneWidget);
  });

  testWidgets('CustomTextField con isRequired true', (tester) async {
    final controller = TextEditingController();
    addTearDown(() => controller.dispose());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            label: 'Nombre requerido',
            controller: controller,
            keyboardType: TextInputType.text,
            isRequired: true,
          ),
        ),
      ),
    );

    expect(find.text('Nombre requerido *'), findsOneWidget);
  });

  testWidgets('CustomTextField con isPrice true', (tester) async {
    final controller = TextEditingController();
    addTearDown(() => controller.dispose());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            label: 'Monto a cancelar',
            controller: controller,
            keyboardType: TextInputType.number,
            isPrice: true,
          ),
        ),
      ),
    );

    expect(find.text('S/ '), findsOneWidget);
  });
}
