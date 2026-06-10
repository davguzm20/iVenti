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

  testWidgets('Sales Credito - flujo completo de venta a credito', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (id_usuario, nombre, email, pin, rol, es_activo) VALUES (1, @nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (id_usuario) DO UPDATE SET email = @email, pin = @pin",
    ), parameters: {
      'nombre': 'E2E Sales Credito', 'email': 'e2e_sales_credito@test.com', 'pin': '123456',
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
      'id_unidad': idUnidad, 'nombre': 'e2e_producto_credito', 'precio': 25.00,
    })).first[0] as int;
    await conn.execute(Sql.named(
      "INSERT INTO lotes (id_producto, fecha_compra, fecha_vencimiento, cantidad_actual, cantidad_comprada, cantidad_perdida, precio_compra, creado_en, actualizado_en) "
      "VALUES (@id_producto, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days', 100, 100, 0, 12.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
    ), parameters: {
      'id_producto': idProducto,
    });
    // Cliente existente para Buscar Cliente
    await conn.execute(Sql.named(
      "INSERT INTO clientes (nombres, apellidos, dni, email, telefono, es_deudor) "
      "VALUES (@nombres, @apellidos, @dni, @email, @telefono, @esDeudor)",
    ), parameters: {
      'nombres': 'e2e_nombre', 'apellidos': 'e2e_apellido', 'dni': '12345678',
      'email': 'e2e_cliente@test.com', 'telefono': '999333333', 'esDeudor': false,
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
    await typeInField(tester, index: 0, text: 'e2e_producto_credito');
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('e2e_producto_credito'));
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
    expect(find.text('e2e_producto_credito'), findsAtLeast(1));
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 1. PaymentPage - toggle a Credito
    expect(find.text('Pago'), findsOneWidget);
    await tester.tap(find.text('Credito'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 2. Confirmar en credito sin cliente -> error
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Cliente requerido'), findsOneWidget);
    await dismissError(tester);

    // 3. Toggle a "Crear Cliente" y confirmar sin nombre -> error
    await tester.tap(find.text('Crear Cliente'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Campos incompletos'), findsOneWidget);
    await dismissError(tester);

    // 4. Llenar datos de nuevo cliente
    await typeInField(tester, index: 0, text: 'Nuevo Cliente E2E');
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 5. Confirmar credito con nuevo cliente -> exitoso
    await typeInField(tester, index: 1, text: '20.00');
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
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
