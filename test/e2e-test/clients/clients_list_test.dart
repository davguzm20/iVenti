import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postgres/postgres.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import '../helpers.dart';
import '../helpers/auth_flows.dart';

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
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (id_usuario, nombre, email, pin, rol, es_activo) VALUES (1, @nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (id_usuario) DO UPDATE SET email = @email, pin = @pin",
    ), parameters: {
      'nombre': 'E2E Clients List', 'email': 'e2e_clients_list@test.com', 'pin': '123456',
    });
    await conn.execute(Sql.named(
      "INSERT INTO clientes (nombres, apellidos, dni, email, telefono, es_deudor) "
      "VALUES (@nombres, @apellidos, @dni, @email, @telefono, @esDeudor)",
    ), parameters: {
      'nombres': 'e2e_regular', 'apellidos': 'test', 'dni': '11111111',
      'email': 'regular@test.com', 'telefono': '999111111', 'esDeudor': false,
    });
    await conn.execute(Sql.named(
      "INSERT INTO clientes (nombres, apellidos, dni, email, telefono, es_deudor) "
      "VALUES (@nombres, @apellidos, @dni, @email, @telefono, @esDeudor)",
    ), parameters: {
      'nombres': 'e2e_deudor', 'apellidos': 'test', 'dni': '22222222',
      'email': 'deudor@test.com', 'telefono': '999222222', 'esDeudor': true,
    });

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
    expect(find.text('e2e_regular test'), findsOneWidget);
    expect(find.text('e2e_deudor test'), findsOneWidget);

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
    await typeInField(tester, index: 0, text: 'e2e_regular');
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 500)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_regular test'), findsAtLeast(1));

    // 3. Limpiar busqueda
    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_regular test'), findsAtLeast(1));
    expect(find.text('e2e_deudor test'), findsAtLeast(1));

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
    expect(find.textContaining('Deudor'), findsOneWidget);

    // 9. Volver
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Mis clientes'), findsOneWidget);

  }, timeout: const Timeout(Duration(seconds: 180)));
}
