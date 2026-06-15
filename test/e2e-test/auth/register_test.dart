import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/shared/services/MailerService.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import '../helpers.dart';
import '../helpers/auth_flows.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: ".env.test");
    MailerService.testCodigoFijo = '123456';
    await PostgresDatasource().connection;
  });

  tearDownAll(() async {
    await cleanTestData();
    MailerService.testCodigoFijo = null;
  });

  testWidgets('Register - flujo completo con todos los casos negativos', (tester) async {
    await cleanTestData();

    await app.main(envFile: ".env.test");
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    await tester.pump();

    expect(find.text('Bienvenido a iVenti'), findsOneWidget);

    await tester.tap(find.text('¿Eres nuevo? Regístrate aquí'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Ingrese su correo electrónico'), findsOneWidget);

    // BackButton: InputEmailPage → WelcomePage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await pumpFrames(tester);
    expect(find.text('Bienvenido a iVenti'), findsOneWidget);

    await tester.tap(find.text('¿Eres nuevo? Regístrate aquí'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Ingrese su correo electrónico'), findsOneWidget);

    await tester.tap(find.text('Confirmar'));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Por favor, ingrese su correo'), findsOneWidget);

    final emailScaffold = find.byType(Scaffold).last;
    final emailField = find
        .descendant(of: emailScaffold, matching: find.byType(EditableText))
        .first;
    final emailState = tester.state<EditableTextState>(emailField);
    emailState.updateEditingValue(
      const TextEditingValue(
        text: 'invalido',
        selection: TextSelection.collapsed(offset: 8),
      ),
    );
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.tap(find.text('Confirmar'));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Ingrese un correo válido'), findsOneWidget);

    emailState.updateEditingValue(
      const TextEditingValue(
        text: 'e2e_auth@test.com',
        selection: TextSelection.collapsed(offset: 18),
      ),
    );
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 5)));
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.tap(find.text('Ok'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(
      find.text('Ingresa el código que enviamos a tu correo'),
      findsOneWidget,
    );

    // BackButton: CodeEmailPage → InputEmailPage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await pumpFrames(tester);
    expect(find.text('Ingrese su correo electrónico'), findsOneWidget);

    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 5)));
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Ok'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(
      find.text('Ingresa el código que enviamos a tu correo'),
      findsOneWidget,
    );

    await testCodeEntry(tester, correctCode: '123456');

    expect(
      find.text('Crea un PIN de 6 dígitos para asegurar tu cuenta'),
      findsOneWidget,
    );

    // BackButton: CreatePinPage(register) → CodeEmailPage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await pumpFrames(tester);
    expect(
      find.text('Ingresa el código que enviamos a tu correo'),
      findsOneWidget,
    );

    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Correcto'), findsOneWidget);
    await dismissError(tester);

    expect(
      find.text('Crea un PIN de 6 dígitos para asegurar tu cuenta'),
      findsOneWidget,
    );

    await tapButton(tester, 'Siguiente');
    await pumpFrames(tester);
    expect(find.text('PIN inválido'), findsOneWidget);
    await tester.tap(find.text('Ok'));
    await tester.pump();
    await tester.pump();

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
      const TextEditingValue(
        text: '123456',
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

    expect(find.text('Completa tu configuración'), findsOneWidget);

    // BackButton: SetupConfigPage → CreatePinPage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await pumpFrames(tester);
    expect(
      find.text('Crea un PIN de 6 dígitos para asegurar tu cuenta'),
      findsOneWidget,
    );

    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Completa tu configuración'), findsOneWidget);

    await tapButton(tester, 'Finalizar');
    await pumpFrames(tester);
    expect(find.text('Nombre requerido'), findsOneWidget);
    expect(find.text('Ingresa tu nombre para continuar'), findsOneWidget);
    await dismissError(tester);

    await typeInField(tester, index: 0, text: 'E2E Test');

    await typeInField(tester, index: 1, text: '');
    await tapButton(tester, 'Finalizar');
    await pumpFrames(tester);
    expect(find.text('Campo incompleto'), findsOneWidget);
    expect(find.text('Ingresa los días antes del vencimiento para recibir alertas'), findsOneWidget);
    await dismissError(tester);

    await typeInField(tester, index: 1, text: '0');
    await tapButton(tester, 'Finalizar');
    await pumpFrames(tester);
    expect(find.text('Valor inválido'), findsOneWidget);
    expect(find.text('Los días de vencimiento deben ser mayor a cero'), findsOneWidget);
    await dismissError(tester);

    await typeInField(tester, index: 1, text: '-1');
    await tapButton(tester, 'Finalizar');
    await pumpFrames(tester);
    expect(find.text('Valor inválido'), findsOneWidget);
    expect(find.text('Los días de vencimiento deben ser mayor a cero'), findsOneWidget);
    await dismissError(tester);

    await typeInField(tester, index: 1, text: '8');

    await typeInField(tester, index: 2, text: '');
    await tapButton(tester, 'Finalizar');
    await pumpFrames(tester);
    expect(find.text('Campo incompleto'), findsOneWidget);
    expect(find.text('Ingresa el stock mínimo para recibir alertas de inventario'), findsOneWidget);
    await dismissError(tester);

    await typeInField(tester, index: 2, text: '0');
    await tapButton(tester, 'Finalizar');
    await pumpFrames(tester);
    expect(find.text('Valor inválido'), findsOneWidget);
    expect(find.text('El stock mínimo debe ser mayor a cero'), findsOneWidget);
    await dismissError(tester);

    await typeInField(tester, index: 2, text: '-1');
    await tapButton(tester, 'Finalizar');
    await pumpFrames(tester);
    expect(find.text('Valor inválido'), findsOneWidget);
    expect(find.text('El stock mínimo debe ser mayor a cero'), findsOneWidget);
    await dismissError(tester);

    await typeInField(tester, index: 2, text: '3');

    await tapButtonAndWait(tester, 'Finalizar', seconds: 30);
    try {
      await tester.pumpUntil(find.text('Configuración completada'), timeout: const Duration(seconds: 60));
    } catch (_) {
      // If not found, check for error dialog
      if (find.text('Error').evaluate().isNotEmpty || find.text('Error inesperado').evaluate().isNotEmpty) {
        await tester.tap(find.text('Ok'));
        await tester.pump();
        await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
      }
    }
    await dismissError(tester);

    expect(find.text('Iniciar sesión'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 360)));
}
