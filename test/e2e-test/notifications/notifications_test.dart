import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/utils/PinEncryptor.dart';
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

  testWidgets('Notifications - flujo completo con todos los casos negativos', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute("SET app.id_usuario = 1");

    final userResult = await conn.execute(
      Sql.named(
        "INSERT INTO usuarios (nombre, email, pin, rol, es_activo) "
        "VALUES (@nombre, @email, @pin, 'OPERATIVO', TRUE) RETURNING id_usuario",
      ),
      parameters: {
        'nombre': 'E2E Test',
        'email': 'e2e_auth@test.com',
        'pin': PinEncryptor.hash('123456'),
      },
    );
    final userId = userResult.first.toColumnMap()['id_usuario'] as int;

    await conn.execute(
      Sql.named(
        "INSERT INTO notificaciones (id_usuario, tipo, titulo, contenido, leida, creado_en) "
        "VALUES (@id, @tipo, @titulo, @contenido, @leida, @creado)",
      ),
      parameters: {
        'id': userId,
        'tipo': 'STOCK_BAJO',
        'titulo': 'E2E Stock bajo',
        'contenido': 'El producto X tiene stock bajo',
        'leida': false,
        'creado': DateTime.now(),
      },
    );

    await conn.execute(
      Sql.named(
        "INSERT INTO notificaciones (id_usuario, tipo, titulo, contenido, leida, creado_en) "
        "VALUES (@id, @tipo, @titulo, @contenido, @leida, @creado)",
      ),
      parameters: {
        'id': userId,
        'tipo': 'PROXIMO_VENCER',
        'titulo': 'E2E Proximo a vencer',
        'contenido': 'Un lote esta proximo a vencer',
        'leida': false,
        'creado': DateTime.now().subtract(const Duration(hours: 2)),
      },
    );

    await conn.execute(
      Sql.named(
        "INSERT INTO notificaciones (id_usuario, tipo, titulo, contenido, leida, creado_en) "
        "VALUES (@id, @tipo, @titulo, @contenido, @leida, @creado)",
      ),
      parameters: {
        'id': userId,
        'tipo': 'STOCK_AGOTADO',
        'titulo': 'E2E Producto agotado',
        'contenido': 'Un producto se ha agotado',
        'leida': true,
        'creado': DateTime.now().subtract(const Duration(days: 2)),
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('device_registered', true);

    await app.main(envFile: ".env.test");
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    await tester.pump();

    expect(find.text('Iniciar sesi\u00f3n'), findsOneWidget);

    final pinField = find.byType(EditableText).first;
    final pinState = tester.state<EditableTextState>(pinField);
    pinState.updateEditingValue(
      const TextEditingValue(
        text: '123456',
        selection: TextSelection.collapsed(offset: 6),
      ),
    );
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

    await tester.tap(find.text('Configuraciones'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.tap(find.byIcon(Icons.notifications_active_outlined));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Notificaciones'), findsOneWidget);

    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('E2E Stock bajo'), findsOneWidget);
    expect(find.text('E2E Proximo a vencer'), findsOneWidget);
    expect(find.text('E2E Producto agotado'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('E2E Stock bajo'), findsNothing);

    await tester.tap(find.byIcon(Icons.done).first);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.byIcon(Icons.done), findsNothing);

    await tester.tap(find.byIcon(Icons.checklist));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.byIcon(Icons.done), findsNothing);

    await tester.tap(find.byIcon(Icons.delete_forever));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('No hay notificaciones'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Configuraci\u00f3n'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 180)));
}
