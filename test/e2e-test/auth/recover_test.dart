import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/shared/services/MailerService.dart';
import 'package:iventi/shared/utils/PinEncryptor.dart';
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

  testWidgets('Recover - flujo completo con todos los casos negativos', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute("SET app.id_usuario = 1");
    await conn.execute(
      Sql.named(
        "INSERT INTO usuarios (id_usuario, nombre, email, pin, es_activo) VALUES (1, @nombre, @email, @pin, TRUE) "
        "ON CONFLICT (id_usuario) DO UPDATE SET pin = @pin",
      ),
      parameters: {
        'nombre': 'E2E Test',
        'email': 'e2e_auth@test.com',
        'pin': PinEncryptor.hash('123456'),
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('device_registered', true);

    await app.main(envFile: ".env.test");
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    await tester.pump();

    expect(find.text('Iniciar sesión'), findsOneWidget);

    await tester.tap(find.text('¿Olvidaste tu PIN?'));
    await tester.pump();
    await waitForAsync(tester);

    await dismissError(tester);

    // BackButton: RecoverPinPage → LoginPage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await pumpFrames(tester);
    expect(find.text('Iniciar sesión'), findsOneWidget);

    await tester.tap(find.text('¿Olvidaste tu PIN?'));
    await tester.pump();
    await waitForAsync(tester);
    await dismissError(tester);

    await testCodeEntry(tester, correctCode: '123456');

    // ===== CREATE PIN PAGE =====
    expect(
      find.text('Crea un PIN de 6 dígitos para asegurar tu cuenta'),
      findsOneWidget,
    );

    // BackButton: CreatePinPage(recovery) → LoginPage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await pumpFrames(tester);
    expect(find.text('Iniciar sesión'), findsOneWidget);

    await tester.tap(find.text('¿Olvidaste tu PIN?'));
    await tester.pump();
    await waitForAsync(tester);
    await dismissError(tester);

    await testCodeEntry(tester, correctCode: '123456');

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

    await tester.tap(find.text('Ok'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 5)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('PIN actualizado'), findsOneWidget);
    await tester.tap(find.text('Ok'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Iniciar sesión'), findsOneWidget);

    await typeInField(tester, text: '999999');
    await tapButtonAndWait(tester, 'Ingresar', seconds: 5);
    expect(find.text('Error de autenticación'), findsOneWidget);
    await dismissError(tester);

    await typeInField(tester, text: '123456');
    await tapButtonAndWait(tester, 'Ingresar', seconds: 20);

    expect(find.text('Mis productos'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 240)));
}
