import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postgres/postgres.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/utils/PinEncryptor.dart';
import 'package:iventi/shared/utils/DniEncryptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  testWidgets('Sales Credito - con cliente existente (Buscar Cliente)', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute("SET app.id_usuario = 1");
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (id_usuario, nombre, email, pin, rol, es_activo) VALUES (1, @nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (id_usuario) DO UPDATE SET email = @email, pin = @pin",
    ), parameters: {
      'nombre': 'E2E Credito Existing', 'email': 'e2e_credito_existing@test.com', 'pin': PinEncryptor.hash('123456'),
    });
    await conn.execute(Sql.named(
      "INSERT INTO unidades (nombre, abreviatura, es_activo, creado_en) "
      "VALUES (@nombre, @abreviatura, TRUE, CURRENT_TIMESTAMP) ON CONFLICT (nombre) DO UPDATE SET es_activo = TRUE",
    ), parameters: {
      'nombre': 'Unidad', 'abreviatura': 'un',
    });
    final idUnidad = (await conn.execute(
      Sql.named("SELECT id_unidad FROM unidades WHERE nombre = @nombre"),
      parameters: {'nombre': 'Unidad'},
    )).first[0] as int;
    final idProducto = (await conn.execute(Sql.named(
      "INSERT INTO productos (id_unidad, nombre, precio, stock_actual, stock_minimo, es_activo, creado_en, actualizado_en) "
      "VALUES (@id_unidad, @nombre, @precio, 50, 5, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id_producto",
    ), parameters: {
      'id_unidad': idUnidad, 'nombre': 'e2e_producto_credito_exist', 'precio': 25.00,
    })).first[0] as int;
    await conn.execute(Sql.named(
      "INSERT INTO lotes (id_producto, fecha_compra, fecha_vencimiento, cantidad_actual, cantidad_comprada, cantidad_perdida, precio_compra, creado_en, actualizado_en) "
      "VALUES (@id_producto, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days', 100, 100, 0, 12.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
    ), parameters: {
      'id_producto': idProducto,
    });
    // Cliente existente
    await conn.execute(Sql.named(
      "INSERT INTO clientes (nombres, dni, email, telefono, es_deudor) "
      "VALUES (@nombres, @dni, @email, @telefono, @esDeudor)",
    ), parameters: {
      'nombres': 'e2e_existing_client', 'dni': DniEncryptor.encryptAES('87654321'),
      'email': 'existing@test.com', 'telefono': '999111222', 'esDeudor': false,
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

    // Navegar a Ventas y crear venta
    await tester.tap(find.text('Ventas'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Crear Venta'), findsOneWidget);

    // Agregar producto
    await tester.tap(find.text('Agregar producto'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    final dialogEditable = find.descendant(of: find.byType(AlertDialog), matching: find.byType(EditableText)).first;
    final dialogState = tester.state<EditableTextState>(dialogEditable);
    dialogState.updateEditingValue(const TextEditingValue(text: 'e2e_producto_credito_exist', selection: TextSelection.collapsed(offset: 26)));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('e2e_producto_credito_exist'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Agregar').last);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_producto_credito_exist'), findsAtLeast(1));
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Pago'), findsOneWidget);

    // 1. Toggle a Credito
    await tester.tap(find.text('Credito'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 2. Toggle a Buscar Cliente
    await tester.tap(find.text('Buscar Cliente'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 3. Buscar cliente existente
    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'e2e_existing');
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 4. Seleccionar cliente de la lista
    await tester.tap(find.text('e2e_existing_client'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.textContaining('e2e_existing_client'), findsAtLeast(1));

    // 5. Confirmar venta a credito con cliente existente
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 5)));
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Venta registrada'), findsOneWidget);
    await tester.tap(find.text('Ok'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 6. Verificar vuelta a SalesPage
    expect(find.text('Mis ventas'), findsOneWidget);

  }, timeout: const Timeout(Duration(seconds: 240)));
}
