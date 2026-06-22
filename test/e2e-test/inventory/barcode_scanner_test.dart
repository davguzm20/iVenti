import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postgres/postgres.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/features/inventory/pages/BarcodeScannerPage.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/utils/PinEncryptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: ".env.test");
    await PostgresDatasource().connection;
  });

  tearDownAll(() async {
    BarcodeScannerPage.testCodigoSimulado = null;
    await cleanTestData();
  });

  testWidgets('Barcode Scanner - escanear desde Crear Producto', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute("SET app.id_usuario = 1");
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (id_usuario, nombre, email, pin, rol, es_activo) VALUES (1, @nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (id_usuario) DO UPDATE SET email = @email, pin = @pin",
    ), parameters: {
      'nombre': 'E2E Scanner', 'email': 'e2e_scanner@test.com', 'pin': PinEncryptor.hash('123456'),
    });
    await conn.execute(Sql.named(
      "INSERT INTO unidades (nombre, abreviatura, es_activo, creado_en) "
      "VALUES (@nombre, @abreviatura, TRUE, CURRENT_TIMESTAMP) ON CONFLICT (nombre) DO UPDATE SET es_activo = TRUE",
    ), parameters: {
      'nombre': 'Unidad', 'abreviatura': 'un',
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

    // Navegar a CreateProduct
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Crear Producto'), findsOneWidget);

    // Ver codigo inicial con guiones
    expect(find.text('-------------'), findsOneWidget);

    // Simular escaneo
    BarcodeScannerPage.testCodigoSimulado = '7501055300013';

    // Encontrar y tap boton escaner (IconButton con icon Image)
    final scannerBtn = find.byWidgetPredicate(
      (w) => w is IconButton && w.icon is Image,
    );
    expect(scannerBtn, findsOneWidget);
    await tester.tap(scannerBtn);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // Verificar que estamos en la pagina del escaner
    expect(find.text('Escanear código'), findsOneWidget);
    expect(find.text('Simular escaneo (testing)'), findsOneWidget);

    // Simular escaneo
    await tester.tap(find.text('Simular escaneo (testing)'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // Verificar codigo escaneado aparece en el campo
    expect(find.text('7501055300013'), findsOneWidget);

  }, timeout: const Timeout(Duration(seconds: 120)));
}
