import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> typeInField(WidgetTester tester, {int index = 0, required String text}) async {
  final scaffold = find.byType(Scaffold).last;
  final fields = find.descendant(of: scaffold, matching: find.byType(EditableText));
  final field = fields.at(index);
  final state = tester.state<EditableTextState>(field);
  state.updateEditingValue(TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  ));
  for (int i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> tapButton(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
}

Future<void> tapButtonAndWait(WidgetTester tester, String text, {int seconds = 2}) async {
  await tester.tap(find.text(text));
  await tester.pump();
  await waitForAsync(tester, seconds: seconds);
}

Future<void> pumpFrames(WidgetTester tester, {int count = 5}) async {
  for (int i = 0; i < count; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> waitForAsync(WidgetTester tester, {int seconds = 1, int pumps = 5}) async {
  await tester.runAsync(() => Future.delayed(Duration(seconds: seconds)));
  for (int i = 0; i < pumps; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> dismissError(WidgetTester tester) async {
  await tapButtonAndWait(tester, 'Ok');
}

Future<void> testCodeEntry(WidgetTester tester, {required String correctCode}) async {
  await tapButton(tester, 'Confirmar');
  await pumpFrames(tester);
  expect(find.text('Error'), findsOneWidget);
  await dismissError(tester);

  await typeInField(tester, text: '999999');
  await tapButtonAndWait(tester, 'Confirmar', seconds: 2);
  expect(find.text('Error'), findsOneWidget);
  expect(
    find.text('El código ingresado es incorrecto. Inténtalo nuevamente.'),
    findsOneWidget,
  );
  await dismissError(tester);

  await typeInField(tester, text: correctCode);
  await tapButtonAndWait(tester, 'Confirmar', seconds: 2);
  expect(find.text('Correcto'), findsOneWidget);
  expect(find.text('¡El código es correcto!'), findsOneWidget);
  await dismissError(tester);
}

Future<void> testPINCreation(WidgetTester tester, {required String pin}) async {
  final pinScaffold = find.byType(Scaffold).last;
  final pinFields = find
      .descendant(of: pinScaffold, matching: find.byType(EditableText));

  final firstPinState = tester.state<EditableTextState>(pinFields.at(0));
  firstPinState.updateEditingValue(
    const TextEditingValue(
      text: '123456',
      selection: TextSelection.collapsed(offset: 6),
    ),
  );
  for (int i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }

  final secondPinState = tester.state<EditableTextState>(pinFields.at(1));
  secondPinState.updateEditingValue(
    const TextEditingValue(
      text: '654321',
      selection: TextSelection.collapsed(offset: 6),
    ),
  );
  for (int i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }

  await tester.tap(find.text('Siguiente'));
  await tester.pump();
  await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }

  expect(find.text('PIN no coincide'), findsOneWidget);
  expect(find.text('Los PIN ingresados no coinciden'), findsOneWidget);

  await tester.tap(find.text('Ok'));
  await tester.pump();
  await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }

  secondPinState.updateEditingValue(
    TextEditingValue(
      text: pin,
      selection: TextSelection.collapsed(offset: pin.length),
    ),
  );
  for (int i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }

  await tester.tap(find.text('Siguiente'));
  await tester.pump();
  await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}
