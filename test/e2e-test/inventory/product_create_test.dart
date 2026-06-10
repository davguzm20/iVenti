import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postgres/postgres.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/features/inventory/pages/BarcodeScannerPage.dart';
import 'package:iventi/features/inventory/pages/ImagePickerPage.dart';
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
    BarcodeScannerPage.testCodigoSimulado = null;
    ImagePickerPage.testRutaSimulada = null;
  });

  Future<void> scrollTap(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(target, 50, scrollable: find.byType(Scrollable).first, maxScrolls: 100);
    await tester.pump();
    await tester.tap(target);
    await tester.pump();
  }

  testWidgets('Create Product - flujo completo de creacion de producto', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (nombre, email, pin, rol, es_activo) VALUES (@nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (email) DO UPDATE SET pin = @pin",
    ), parameters: {
      'nombre': 'E2E Create Product', 'email': 'e2e_create_product@test.com', 'pin': '123456',
    });
    await conn.execute(Sql.named(
      "INSERT INTO unidades (nombre, abreviatura, es_activo, creado_en) "
      "VALUES (@nombre, @abreviatura, TRUE, CURRENT_TIMESTAMP) ON CONFLICT (nombre) DO UPDATE SET es_activo = TRUE",
    ), parameters: {
      'nombre': 'Kilogramo', 'abreviatura': 'kg',
    });
    await conn.execute(Sql.named(
      "INSERT INTO categorias (nombre, es_activo, creado_en, actualizado_en) "
      "VALUES (@nombre, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) ON CONFLICT (nombre) DO NOTHING",
    ), parameters: {
      'nombre': 'e2e_cat_test',
    });
    await conn.execute(Sql.named(
      "INSERT INTO categorias (nombre, es_activo, creado_en, actualizado_en) "
      "VALUES (@nombre, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) ON CONFLICT (nombre) DO NOTHING",
    ), parameters: {
      'nombre': 'e2e_cat_delete',
    });

    final testCatId = (await conn.execute(
      Sql.named("SELECT id_categoria FROM categorias WHERE nombre = @nombre"),
      parameters: {'nombre': 'e2e_cat_test'},
    )).first[0] as int;
    final deleteCatId = (await conn.execute(
      Sql.named("SELECT id_categoria FROM categorias WHERE nombre = @nombre"),
      parameters: {'nombre': 'e2e_cat_delete'},
    )).first[0] as int;

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

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Crear Producto'), findsOneWidget);

    // 1. Scanner navigation + simulated code
    BarcodeScannerPage.testCodigoSimulado = '1234567890';
    final scannerImage = find.image(const AssetImage('lib/assets/iconos/iconoBarras.png'));
    final scannerButton = find.ancestor(of: scannerImage, matching: find.byType(IconButton));
    await tester.ensureVisible(scannerButton);
    await tester.pump();
    await tester.tap(scannerButton);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Escanear código'), findsOneWidget);
    expect(find.text('Simular escaneo (testing)'), findsOneWidget);
    await tester.tap(find.text('Simular escaneo (testing)'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Crear Producto'), findsOneWidget);
    expect(find.text('1234567890'), findsOneWidget);
    BarcodeScannerPage.testCodigoSimulado = null;

    // 2. Image picker navigation + simulated path
    final tmpDir = Directory.systemTemp;
    final imgFile = File('${tmpDir.path}/e2e_test_img.png');
    await imgFile.writeAsBytes(base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=='));
    ImagePickerPage.testRutaSimulada = imgFile.path;
    final pickerImage = find.image(const AssetImage('lib/assets/iconos/iconoImagen.png'));
    final pickerButton = find.ancestor(of: pickerImage, matching: find.byType(IconButton));
    await tester.ensureVisible(pickerButton);
    await tester.pump();
    await tester.tap(pickerButton);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Seleccionar imagen'), findsOneWidget);
    await tester.tap(find.text('Tomar foto'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Crear Producto'), findsOneWidget);
    ImagePickerPage.testRutaSimulada = null;

    // 3. Validation: campos incompletos (name empty)
    await typeInField(tester, index: 0, text: '');
    await typeInField(tester, index: 1, text: '');
    await typeInField(tester, index: 3, text: '');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.ensureVisible(find.text('Confirmar'));
    await tester.pump();
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Campos incompletos'), findsOneWidget);
    await dismissError(tester);

    // 4. Validation: stock = 0
    await typeInField(tester, index: 0, text: 'e2e_producto_test');
    await typeInField(tester, index: 1, text: '0');
    await typeInField(tester, index: 3, text: '15.50');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.ensureVisible(find.text('Confirmar'));
    await tester.pump();
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Stock mínimo inválido'), findsOneWidget);
    await dismissError(tester);

    // 5. Validation: price = 0
    await typeInField(tester, index: 1, text: '5');
    await typeInField(tester, index: 3, text: '0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.ensureVisible(find.text('Confirmar'));
    await tester.pump();
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Precio inválido'), findsOneWidget);
    await dismissError(tester);

    // Fix price
    await typeInField(tester, index: 3, text: '15.50');

    // 6. Add category via dialog (sub-dialog)
    await tester.ensureVisible(find.text('Agregar categoría'));
    await tester.pump();
    await tester.tap(find.text('Agregar categoría'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Agregar nueva categoría'), findsOneWidget);
    final catField = find.byType(EditableText).last;
    final catState = tester.state<EditableTextState>(catField);
    catState.updateEditingValue(const TextEditingValue(text: 'e2e_cat_nueva', selection: TextSelection.collapsed(offset: 14)));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Guardar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Crear Producto'), findsOneWidget);

    // 7. Select FilterChip category
    await tester.ensureVisible(find.text('e2e_cat_test'));
    await tester.pump();
    await tester.tap(find.text('e2e_cat_test'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 8. Edit category via dropdown: e2e_cat_test -> e2e_cat_renamed
    await tester.ensureVisible(find.text('Editar categoría'));
    await tester.pump();
    await tester.tap(find.text('Editar categoría'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Guardar'), findsOneWidget);

    final editDialog = find.byType(AlertDialog);
    final editDropdown = find.descendant(of: editDialog, matching: find.byType(DropdownButtonFormField<int>));
    final editDropdownState = tester.state<FormFieldState<int>>(editDropdown);
    editDropdownState.didChange(testCatId);
    await tester.pump();
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    final renameField = find.descendant(of: editDialog, matching: find.byType(EditableText));
    final renameState = tester.state<EditableTextState>(renameField);
    renameState.updateEditingValue(const TextEditingValue(text: 'e2e_cat_renamed', selection: TextSelection.collapsed(offset: 15)));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Guardar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Crear Producto'), findsOneWidget);
    expect(find.text('e2e_cat_renamed'), findsOneWidget);
    expect(find.text('e2e_cat_test'), findsNothing);

    // 9. Delete category via dropdown: e2e_cat_delete
    await tester.ensureVisible(find.text('Eliminar categoría'));
    await tester.pump();
    await tester.tap(find.text('Eliminar categoría'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Eliminar'), findsOneWidget);

    final deleteDialog = find.byType(AlertDialog);
    final deleteDropdown = find.descendant(of: deleteDialog, matching: find.byType(DropdownButtonFormField<int>));
    final deleteDropdownState = tester.state<FormFieldState<int>>(deleteDropdown);
    deleteDropdownState.didChange(deleteCatId);
    await tester.pump();
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.tap(find.text('Eliminar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Crear Producto'), findsOneWidget);
    expect(find.text('e2e_cat_delete'), findsNothing);

    // 10. Cancel creation
    await scrollTap(tester, find.text('Cancelar'));
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Mis productos'), findsOneWidget);

    // 11. Create product successfully
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Crear Producto'), findsOneWidget);

    await typeInField(tester, index: 0, text: 'e2e_producto_test');
    await typeInField(tester, index: 1, text: '5');
    await typeInField(tester, index: 3, text: '15.50');

    await tester.ensureVisible(find.text('e2e_cat_nueva'));
    await tester.pump();
    await tester.tap(find.text('e2e_cat_nueva'));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await scrollTap(tester, find.text('Confirmar'));
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Confirmación'), findsOneWidget);
    await tester.tap(find.text('Ok'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 5)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Producto registrado'), findsOneWidget);
    await dismissError(tester);

    // 12. Product in list
    expect(find.text('Mis productos'), findsOneWidget);
    expect(find.text('e2e_producto_test'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 240)));
}
