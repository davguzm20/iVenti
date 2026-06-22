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

  testWidgets('Product - flujo completo de detalle, lotes y edicion', (tester) async {
    await cleanTestData();

    final conn = await PostgresDatasource().connection;
    await conn.execute("SET app.id_usuario = 1");
    await conn.execute(Sql.named(
      "INSERT INTO usuarios (id_usuario, nombre, email, pin, rol, es_activo) VALUES (1, @nombre, @email, @pin, 'OPERATIVO', TRUE) "
      "ON CONFLICT (id_usuario) DO UPDATE SET pin = @pin",
    ), parameters: {
      'nombre': 'E2E Product Detail', 'email': 'e2e_product_detail@test.com', 'pin': PinEncryptor.hash('123456'),
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
    final idProducto = (await conn.execute(Sql.named(
      "INSERT INTO productos (id_unidad, nombre, precio, stock_actual, stock_minimo, es_activo, creado_en, actualizado_en) "
      "VALUES (@id_unidad, @nombre, @precio, 10, 5, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id_producto",
    ), parameters: {
      'id_unidad': idUnidad, 'nombre': 'e2e_producto_detail', 'precio': 25.00,
    })).first[0] as int;
    await conn.execute(Sql.named(
      "INSERT INTO categorias (nombre, es_activo, creado_en, actualizado_en) "
      "VALUES (@nombre, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) ON CONFLICT (nombre) DO NOTHING",
    ), parameters: {
      'nombre': 'e2e_cat_producto',
    });
    await conn.execute(Sql.named(
      "INSERT INTO categorias (nombre, es_activo, creado_en, actualizado_en) "
      "VALUES (@nombre, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) ON CONFLICT (nombre) DO NOTHING",
    ), parameters: {
      'nombre': 'e2e_cat_para_agregar',
    });
    final idCatProducto = (await conn.execute(
      Sql.named("SELECT id_categoria FROM categorias WHERE nombre = @nombre"),
      parameters: {'nombre': 'e2e_cat_producto'},
    )).first[0] as int;
    final idCatAgregar = (await conn.execute(
      Sql.named("SELECT id_categoria FROM categorias WHERE nombre = @nombre"),
      parameters: {'nombre': 'e2e_cat_para_agregar'},
    )).first[0] as int;
    await conn.execute(Sql.named(
      "INSERT INTO categorias_productos (id_producto, id_categoria) VALUES (@id_producto, @id_categoria)",
    ), parameters: {
      'id_producto': idProducto,
      'id_categoria': idCatProducto,
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
    expect(find.text('e2e_producto_detail'), findsOneWidget);

    // Navegar a detalle
    await tester.tap(find.text('e2e_producto_detail'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_producto_detail'), findsOneWidget);

    // 1. Ver detalle
    expect(find.textContaining('Precio:'), findsOneWidget);
    expect(find.textContaining('Stock actual:'), findsOneWidget);
    expect(find.textContaining('Stock mínimo:'), findsOneWidget);
    expect(find.textContaining('Unidad:'), findsOneWidget);

    // 2. Ver categorias del producto
    expect(find.text('e2e_cat_producto'), findsOneWidget);

    // 3. Scroll to categories section and toggle edit mode
    await tester.scrollUntilVisible(
      find.text('Categorías'),
      50,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 100,
    );
    await tester.pump();
    final catEditToggle = find.descendant(
      of: find.byType(ListView),
      matching: find.byIcon(Icons.edit),
    );
    await tester.tap(catEditToggle);
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.ensureVisible(find.text('+ Crear nueva categoría'));
    await tester.pump();

    // 4. Crear nueva categoria desde ProductPage
    await tester.tap(find.text('+ Crear nueva categoría'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Nueva categoría'), findsOneWidget);

    final nuevaCatDialog = find.byType(AlertDialog);
    final nuevaCatField = find.descendant(of: nuevaCatDialog, matching: find.byType(EditableText));
    final nuevaCatState = tester.state<EditableTextState>(nuevaCatField);
    nuevaCatState.updateEditingValue(const TextEditingValue(text: 'e2e_cat_creada', selection: TextSelection.collapsed(offset: 15)));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Crear'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_producto_detail'), findsOneWidget);

    // 5. Agregar categoria a producto via dropdown
    await tester.tap(find.text('+ Agregar categoría'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Agregar categoría'), findsOneWidget);

    final agregarDialog = find.byType(AlertDialog);
    final agregarDropdown = find.descendant(of: agregarDialog, matching: find.byType(DropdownButtonFormField<int>));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    final agregarState = tester.state<FormFieldState<int>>(agregarDropdown);
    agregarState.didChange(idCatAgregar);
    await tester.pump();
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Agregar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_producto_detail'), findsOneWidget);

    // 6. Eliminar categoria de producto (FilterChip tap)
    await tester.ensureVisible(find.text('e2e_cat_producto'));
    await tester.pump();
    await tester.tap(find.text('e2e_cat_producto'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_cat_producto'), findsNothing);

    // 7. Sin lotes
    expect(find.text('Aún no hay lotes creados para este producto.'), findsOneWidget);

    // 8. Cancelar agregar lote
    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Agregar lote'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_producto_detail'), findsOneWidget);

    // 9. Agregar lote valido
    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Agregar lote'), findsOneWidget);
    final loteDialog = find.byType(AlertDialog);
    final loteFields = find.descendant(of: loteDialog, matching: find.byType(EditableText));
    tester.state<EditableTextState>(loteFields.at(0)).updateEditingValue(const TextEditingValue(text: '15', selection: TextSelection.collapsed(offset: 2)));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    tester.state<EditableTextState>(loteFields.at(2)).updateEditingValue(const TextEditingValue(text: '30.00', selection: TextSelection.collapsed(offset: 5)));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Guardar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_producto_detail'), findsOneWidget);

    // 10. Ver lote en lista
    expect(find.textContaining('Cantidad Actual: 15'), findsOneWidget);

    // 11. Editar producto
    final editIcon = find.descendant(of: find.byType(AppBar).last, matching: find.byIcon(Icons.edit));
    await tester.tap(editIcon);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Editar Producto'), findsOneWidget);

    // 12. Cancelar editar
    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_producto_detail'), findsOneWidget);

    // 13. Editar y guardar cambios
    await tester.tap(editIcon);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Editar Producto'), findsOneWidget);
    final editDialog = find.byType(AlertDialog);
    final editFields = find.descendant(of: editDialog, matching: find.byType(EditableText));
    tester.state<EditableTextState>(editFields.at(1)).updateEditingValue(const TextEditingValue(text: 'e2e_producto_editado', selection: TextSelection.collapsed(offset: 21)));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Guardar'), warnIfMissed: false);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 5)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 14. Ver cambios reflejados
    expect(find.text('e2e_producto_editado'), findsOneWidget);

    // 15. Eliminar lote via PopupMenu
    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.tap(find.text('Eliminar'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Eliminar lote'), findsOneWidget);
    await tester.tap(find.text('Ok'));
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('e2e_producto_editado'), findsOneWidget);

    // 16. Verificar cambios guardados
    await tester.tap(find.byIcon(Icons.arrow_back), warnIfMissed: false);
    await tester.pump();
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // 17. Verificar producto editado en inventory
    expect(find.text('Mis productos'), findsOneWidget);
    expect(find.text('e2e_producto_editado'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 240)));
}
