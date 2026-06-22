import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postgres/postgres.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/features/sales/pages/FilterSalesPage.dart';
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
    FilterSalesPage.testFechaFija = null;
  });

  testWidgets('Sales List - flujo completo de listado y filtros', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute("SET app.id_usuario = 1");
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (id_usuario, nombre, email, pin, rol, es_activo) VALUES (1, @nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (id_usuario) DO UPDATE SET pin = @pin",
    ), parameters: {
      'nombre': 'E2E Sales List', 'email': 'e2e_sales_list@test.com', 'pin': PinEncryptor.hash('123456'),
    });
    final idUser = 1;
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
      "VALUES (@id_unidad, @nombre, @precio, 10, 5, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id_producto",
    ), parameters: {
      'id_unidad': idUnidad, 'nombre': 'e2e_producto_list', 'precio': 20.00,
    })).first[0] as int;
    await conn.execute(Sql.named(
      "INSERT INTO lotes (id_producto, fecha_compra, fecha_vencimiento, cantidad_actual, cantidad_comprada, cantidad_perdida, precio_compra, creado_en, actualizado_en) "
      "VALUES (@id_producto, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days', 100, 100, 0, 10.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
    ), parameters: {
      'id_producto': idProducto,
    });
    final idLote = (await conn.execute(
      Sql.named("SELECT id_lote FROM lotes WHERE id_producto = @id_producto"),
      parameters: {'id_producto': idProducto},
    )).first[0] as int;
    // Seed venta
    final idCliente = (await conn.execute(
      "INSERT INTO clientes (nombres, dni, creado_en) "
      "VALUES ('e2e_contado', '${DniEncryptor.encryptAES('00000000')}', CURRENT_TIMESTAMP) RETURNING id_cliente",
    )).first[0] as int;
    final idVenta = (await conn.execute(Sql.named(
      "INSERT INTO ventas (id_cliente, id_usuario, monto_total, monto_cancelado, estado, es_credito, creado_en, actualizado_en) "
      "VALUES (@idCliente, @idUsuario, @montoTotal, @montoCancelado, @estado, @esCredito, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id_venta",
    ), parameters: {
      'idCliente': idCliente, 'idUsuario': idUser, 'montoTotal': 40.00, 'montoCancelado': 40.00,
      'estado': 'COMPLETADA', 'esCredito': false,
    })).first[0] as int;
    await conn.execute(Sql.named(
      "INSERT INTO detalle_ventas (id_venta, id_lote, cantidad, precio_unitario, subtotal, descuento, creado_en) "
      "VALUES (@idVenta, @idLote, @cantidad, @precio, @subtotal, 0, CURRENT_TIMESTAMP)",
    ), parameters: {
      'idVenta': idVenta, 'idLote': idLote, 'cantidad': 2, 'precio': 20.00, 'subtotal': 40.00,
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

    // 1. Ver venta en listado
    expect(find.text('Venta $idVenta'), findsOneWidget);

    // 2. Buscar icono toggle
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Buscar venta...'), findsOneWidget);

    // 3. Cerrar busqueda
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Venta $idVenta'), findsOneWidget);

    // 4. Navegar a filtros
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Filtros de Ventas'), findsOneWidget);

    // 5. Activar filtro tipo pago -> Al contado
    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Al contado'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 6. Cambiar a Credito
    if (find.text('Credito').evaluate().isNotEmpty) {
      await tester.tap(find.text('Credito'));
      await tester.pump();
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    // 7. Activar filtro por fecha con testFechaFija
    FilterSalesPage.testFechaFija = DateTime(2025, 1, 15);
    await tester.tap(find.byType(SwitchListTile).last);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.byIcon(Icons.calendar_today).first);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.byIcon(Icons.calendar_today).last);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    FilterSalesPage.testFechaFija = null;

    // 8. Toggle fecha off -> resetea
    await tester.tap(find.byType(SwitchListTile).last);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 9. Aplicar filtros
    await tester.tap(find.text('Aplicar Filtros'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 10. Back desde filtro sin aplicar
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Venta $idVenta'), findsOneWidget);

  }, timeout: const Timeout(Duration(seconds: 180)));
}
