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

  testWidgets('Sales List - buscar venta por codigo_boleta', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute("SET app.id_usuario = 1");
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (id_usuario, nombre, email, pin, rol, es_activo) VALUES (1, @nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (id_usuario) DO UPDATE SET email = @email, pin = @pin",
    ), parameters: {
      'nombre': 'E2E Search Boleta', 'email': 'e2e_search_boleta@test.com', 'pin': PinEncryptor.hash('123456'),
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
      'id_unidad': idUnidad, 'nombre': 'e2e_producto_search', 'precio': 10.00,
    })).first[0] as int;
    final idLote = (await conn.execute(Sql.named(
      "INSERT INTO lotes (id_producto, fecha_compra, fecha_vencimiento, cantidad_actual, cantidad_comprada, cantidad_perdida, precio_compra, creado_en, actualizado_en) "
      "VALUES (@id_producto, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days', 100, 100, 0, 5.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id_lote",
    ), parameters: {
      'id_producto': idProducto,
    })).first[0] as int;
    final idCliente = (await conn.execute(
      "INSERT INTO clientes (nombres, dni, creado_en) "
      "VALUES ('e2e_search', '${DniEncryptor.encryptAES('00000002')}', CURRENT_TIMESTAMP) RETURNING id_cliente",
    )).first[0] as int;

    // Crear venta con codigo_boleta generado (monto_total > 5)
    final idVenta = (await conn.execute(Sql.named(
      "INSERT INTO ventas (id_cliente, id_usuario, monto_total, monto_cancelado, estado, es_credito, codigo_boleta, creado_en, actualizado_en) "
      "VALUES (@idCliente, 1, @montoTotal, @montoCancelado, @estado, @esCredito, generar_codigo_boleta(), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id_venta, codigo_boleta",
    ), parameters: {
      'idCliente': idCliente, 'montoTotal': 20.00, 'montoCancelado': 20.00,
      'estado': 'COMPLETADA', 'esCredito': false,
    })).first.toColumnMap();
    await conn.execute(Sql.named(
      "INSERT INTO detalle_ventas (id_venta, id_lote, cantidad, precio_unitario, subtotal, descuento, creado_en) "
      "VALUES (@idVenta, @idLote, @cantidad, @precio, @subtotal, 0, CURRENT_TIMESTAMP)",
    ), parameters: {
      'idVenta': idVenta['id_venta'], 'idLote': idLote, 'cantidad': 2, 'precio': 10.00, 'subtotal': 20.00,
    });
    final codigoBoleta = idVenta['codigo_boleta'] as String;

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

    // Navegar a Ventas
    await tester.tap(find.text('Ventas'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Venta ${idVenta['id_venta']}'), findsOneWidget);

    // 1. Abrir busqueda
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Buscar venta...'), findsOneWidget);

    // 2. Buscar por codigo_boleta
    final searchField = find.byType(TextField);
    await tester.enterText(searchField, codigoBoleta);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 3. Verificar que la venta aparece
    expect(find.text('Venta ${idVenta['id_venta']}'), findsOneWidget);

    // 4. Buscar codigo inexistente
    await tester.enterText(searchField, 'XXXXXX');
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Venta ${idVenta['id_venta']}'), findsNothing);

  }, timeout: const Timeout(Duration(seconds: 180)));
}
