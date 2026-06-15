import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/shared/utils/PinEncryptor.dart';
import 'package:iventi/shared/utils/DniEncryptor.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import '../helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: ".env.test");
    await PostgresDatasource().connection;
  });

  tearDownAll(() async {
    await cleanTestData();
  });

  testWidgets('Clients List - flujo completo de listado y filtros', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute("SET app.id_usuario = 1");
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (id_usuario, nombre, email, pin, rol, es_activo) VALUES (1, @nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (id_usuario) DO UPDATE SET email = @email, pin = @pin",
    ), parameters: {
      'nombre': 'E2E Clients List', 'email': 'e2e_clients_list@test.com', 'pin': PinEncryptor.hash('123456'),
    });
    await conn.execute(Sql.named(
      "INSERT INTO clientes (nombres, dni, email, telefono, es_deudor) "
      "VALUES (@nombres, @dni, @email, @telefono, @esDeudor)",
    ), parameters: {
      'nombres': 'e2e_regular', 'dni': DniEncryptor.encryptAES('11111111'),
      'email': 'regular@test.com', 'telefono': '999111111', 'esDeudor': false,
    });
    await conn.execute(Sql.named(
      "INSERT INTO clientes (nombres, dni, email, telefono, es_deudor) "
      "VALUES (@nombres, @dni, @email, @telefono, @esDeudor)",
    ), parameters: {
      'nombres': 'e2e_deudor', 'dni': DniEncryptor.encryptAES('22222222'),
      'email': 'deudor@test.com', 'telefono': '999222222', 'esDeudor': true,
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('device_registered', true);

    await app.main(envFile: ".env.test");
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    await tester.pump();
    expect(find.text('Iniciar sesión'), findsOneWidget);

    final pinField = find.byType(EditableText).first;
    final pinState = tester.state<EditableTextState>(pinField);
    pinState.updateEditingValue(const TextEditingValue(text: '123456', selection: TextSelection.collapsed(offset: 6)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Ingresar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 20)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Mis productos'), findsOneWidget);

    // Navegar a Clientes (bottom nav index 2)
    await tester.tap(find.text('Clientes'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 1. Clientes en listado
    expect(find.text('e2e_regular'), findsOneWidget);
    expect(find.text('e2e_deudor'), findsOneWidget);

    // 2. Buscar por nombre
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    final searchField = find.byType(TextField).first;
    await tester.tap(searchField);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    final appBarEditable = find.descendant(of: find.byType(AppBar), matching: find.byType(EditableText)).first;
    final appBarState = tester.state<EditableTextState>(appBarEditable);
    appBarState.updateEditingValue(const TextEditingValue(text: 'e2e_regular', selection: TextSelection.collapsed(offset: 12)));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_regular'), findsAtLeast(1));

    // 3. Limpiar busqueda
    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_regular'), findsAtLeast(1));
    expect(find.text('e2e_deudor'), findsAtLeast(1));

    // 4. Navegar a filtros
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Filtrar clientes'), findsOneWidget);

    // 5. Activar filtro
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Deudores'), findsOneWidget);

    // 6. Seleccionar Deudores
    await tester.tap(find.text('Deudores'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 7. Aplicar filtros
    await tester.tap(find.text('Aplicar Filtros'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 8. Navegar a detalle (usando icono visibility del ClientCard)
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.textContaining('DEUDOR'), findsOneWidget);

    // 9. Volver
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Mis clientes'), findsOneWidget);

  }, timeout: const Timeout(Duration(seconds: 180)));
}
