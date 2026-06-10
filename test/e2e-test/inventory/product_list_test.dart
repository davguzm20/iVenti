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

  testWidgets('Inventory - flujo completo de listado, busqueda y filtros', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (nombre, email, pin, rol, es_activo) VALUES (@nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (email) DO UPDATE SET pin = @pin",
    ), parameters: {
      'nombre': 'E2E Inventory List', 'email': 'e2e_inv_list@test.com', 'pin': '123456',
    });
    await conn.execute(Sql.named(
      "INSERT INTO unidades (nombre, abreviatura, es_activo, creado_en) "
      "VALUES (@nombre, @abreviatura, TRUE, CURRENT_TIMESTAMP) ON CONFLICT (nombre) DO UPDATE SET es_activo = TRUE",
    ), parameters: {
      'nombre': 'Kilogramo', 'abreviatura': 'kg',
    });
    final idUnidad = (await conn.execute(
      Sql.named("SELECT id_unidad FROM unidades WHERE nombre = @nombre"),
      parameters: {'nombre': 'Kilogramo'},
    )).first[0] as int;
    await conn.execute(Sql.named(
      "INSERT INTO productos (id_unidad, nombre, precio, stock_actual, stock_minimo, es_activo, creado_en, actualizado_en) "
      "VALUES (@id_unidad, @nombre, @precio, 10, 5, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
    ), parameters: {
      'id_unidad': idUnidad, 'nombre': 'e2e_producto_list', 'precio': 25.00,
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

    // 1. Producto en lista
    expect(find.text('e2e_producto_list'), findsOneWidget);

    // 2. Buscar por nombre (typeInField evita teclado)
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await typeInField(tester, text: 'e2e_producto_list');
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 500)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_producto_list'), findsAtLeast(1));

    // 3. Limpiar busqueda
    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 4. Navegar a filtros
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Filtrar productos'), findsOneWidget);

    // 5. Filtro stock bajo + aplicar
    await tester.tap(find.text('Filtrar por Stock'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Aplicar Filtros'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Mis productos'), findsOneWidget);

    // 6. Filtro stock normal + aplicar
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Filtrar productos'), findsOneWidget);
    await tester.tap(find.text('Stock Normal'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Aplicar Filtros'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Mis productos'), findsOneWidget);

    // 7. Filtro combo (stock bajo + categorias) + aplicar
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Filtrar productos'), findsOneWidget);
    await tester.tap(find.text('Filtrar por Stock'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Filtrar por Categorías'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Aplicar Filtros'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Mis productos'), findsOneWidget);

    // 8. Retroceder sin aplicar
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Filtrar productos'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Mis productos'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 240)));
}
