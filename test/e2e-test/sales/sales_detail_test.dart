import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postgres/postgres.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/utils/PinEncryptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  testWidgets('Sales Detail - flujo completo de detalle, pago y anular', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute("SET app.id_usuario = 1");
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (id_usuario, nombre, email, pin, rol, es_activo) VALUES (1, @nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (id_usuario) DO UPDATE SET email = @email, pin = @pin",
    ), parameters: {
      'nombre': 'E2E Sales Detail', 'email': 'e2e_sales_detail@test.com', 'pin': PinEncryptor.hash('123456'),
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
      'id_unidad': idUnidad, 'nombre': 'e2e_producto_detail', 'precio': 25.00,
    })).first[0] as int;
    final idLote = (await conn.execute(Sql.named(
      "INSERT INTO lotes (id_producto, fecha_compra, fecha_vencimiento, cantidad_actual, cantidad_comprada, cantidad_perdida, precio_compra, creado_en, actualizado_en) "
      "VALUES (@id_producto, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days', 100, 100, 0, 12.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id_lote",
    ), parameters: {
      'id_producto': idProducto,
    })).first[0] as int;
    final idCliente = (await conn.execute(Sql.named(
      "INSERT INTO clientes (nombres, dni, creado_en) "
      "VALUES ('e2e_credito', 'e2e_00000001', CURRENT_TIMESTAMP) RETURNING id_cliente",
    ))).first[0] as int;
    final idVenta = (await conn.execute(Sql.named(
      "INSERT INTO ventas (id_cliente, id_usuario, monto_total, monto_cancelado, estado, es_credito, creado_en, actualizado_en) "
      "VALUES (@idCliente, @idUsuario, @montoTotal, @montoCancelado, @estado, @esCredito, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id_venta",
    ), parameters: {
      'idCliente': idCliente, 'idUsuario': 1, 'montoTotal': 50.00, 'montoCancelado': 20.00,
      'estado': 'PENDIENTE', 'esCredito': true,
    })).first[0] as int;
    await conn.execute(Sql.named(
      "INSERT INTO detalle_ventas (id_venta, id_lote, cantidad, precio_unitario, subtotal, descuento, creado_en) "
      "VALUES (@idVenta, @idLote, @cantidad, @precio, @subtotal, 0, CURRENT_TIMESTAMP)",
    ), parameters: {
      'idVenta': idVenta, 'idLote': idLote, 'cantidad': 2, 'precio': 25.00, 'subtotal': 50.00,
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

    // Navegar a Ventas
    await tester.tap(find.text('Ventas'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Venta $idVenta'), findsOneWidget);

    // Navegar a detalle
    await tester.tap(find.text('Venta $idVenta'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Detalles'), findsOneWidget);

    // 1. Verificar datos de venta
    expect(find.textContaining('50.00'), findsAtLeast(1));
    expect(find.textContaining('Crédito'), findsAtLeast(1));

    // 2. Generar PDF desde boton print
    await tester.tap(find.byIcon(Icons.print));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Visor de PDF'), findsOneWidget);

    // 3. Compartir desde visor PDF
    await tester.tap(find.byIcon(Icons.share));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    // Volver del visor
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Detalles'), findsOneWidget);

    // 4. Pagar deuda parcial -> abrir dialogo
    await tester.tap(find.byIcon(Icons.attach_money));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Cancelar deuda'), findsOneWidget);

    // 5. Monto invalido (0) -> error
    await typeInField(tester, text: '0');
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Aceptar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Monto invalido'), findsOneWidget);
    await dismissError(tester);

    // 6. Monto excedido (> pendiente) -> error
    await typeInField(tester, text: '50.00');
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Aceptar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Monto excedido'), findsOneWidget);
    await dismissError(tester);

    // 7. Monto valido -> pago exitoso
    await typeInField(tester, text: '30.00');
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Aceptar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 5)));
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Pago registrado'), findsOneWidget);
    await tester.tap(find.text('Ok'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 8. Anular venta
    await tester.tap(find.byIcon(Icons.block));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Anular venta'), findsOneWidget);
    await tester.tap(find.text('Anular').last);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 9. Verificar retorno a SalesPage
    expect(find.text('Mis ventas'), findsOneWidget);

  }, timeout: const Timeout(Duration(seconds: 240)));
}
