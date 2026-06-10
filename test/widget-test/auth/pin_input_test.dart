import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/auth/widgets/PinInput.dart';

void main() {
  group('PinInput', () {
    group('renderizado', () {
      testWidgets('debe renderizar correctamente con valores por defecto', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PinInput(),
            ),
          ),
        );

        expect(find.byType(PinInput), findsOneWidget);
      });

      testWidgets('debe renderizar con longitud personalizada', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PinInput(length: 4),
            ),
          ),
        );

        expect(find.byType(PinInput), findsOneWidget);
      });

      testWidgets('debe renderizar con obscureText activado', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PinInput(obscureText: true),
            ),
          ),
        );

        expect(find.byType(PinInput), findsOneWidget);
      });
    });

    group('interaccion', () {
      testWidgets('debe llamar a onCompleted cuando se completa el PIN', (WidgetTester tester) async {
        String? completedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 6,
                onCompleted: (value) => completedValue = value,
              ),
            ),
          ),
        );

        final finder = find.byType(PinInput);
        await tester.enterText(finder, '123456');
        await tester.pumpAndSettle();

        expect(completedValue, '123456');
      });

      testWidgets('debe llamar a onChanged cuando cambia el valor', (WidgetTester tester) async {
        String? changedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        );

        final finder = find.byType(PinInput);
        await tester.enterText(finder, '123');
        await tester.pump();

        expect(changedValue, '123');
      });
    });

    group('estados', () {
      testWidgets('debe cambiar de estado cuando se completa el PIN', (WidgetTester tester) async {
        bool completed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 6,
                onCompleted: (value) => completed = true,
              ),
            ),
          ),
        );

        final finder = find.byType(PinInput);
        await tester.enterText(finder, '123456');
        await tester.pumpAndSettle();

        expect(completed, isTrue);
      });
    });
  });
}