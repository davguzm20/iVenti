import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';

import 'package:iventi/shared/utils/PostgresDatasource.dart';

Future<void> bootstrapE2E() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.test");
}

/// Suprime errores de overflow en flujos donde el framework Flutter
/// genera constraints angostas (e.g. ~76px) durante transiciones GoRouter
/// con parentNavigatorKey.
void suppressOverflowErrors() {
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('RenderFlex')) {
      return;
    }
    FlutterError.presentError(details);
  };
}

Future<void> cleanTestData() async {
  final datasource = PostgresDatasource();
  final conn = await datasource.connection;

  await conn.execute(
    "DELETE FROM detalle_ventas WHERE id_venta IN (SELECT id_venta FROM ventas WHERE id_usuario IN (SELECT id_usuario FROM usuarios WHERE email LIKE 'e2e_%'))",
  );
  await conn.execute(
    "DELETE FROM recibos WHERE id_venta IN (SELECT id_venta FROM ventas WHERE id_usuario IN (SELECT id_usuario FROM usuarios WHERE email LIKE 'e2e_%'))",
  );
  await conn.execute(
    "DELETE FROM ventas WHERE id_usuario IN (SELECT id_usuario FROM usuarios WHERE email LIKE 'e2e_%')",
  );
  await conn.execute(
    "DELETE FROM notificaciones WHERE id_usuario IN (SELECT id_usuario FROM usuarios WHERE email LIKE 'e2e_%')",
  );
  await conn.execute(
    "DELETE FROM categorias_productos WHERE id_producto IN (SELECT id_producto FROM productos WHERE nombre LIKE 'e2e_%')",
  );
  await conn.execute(
    "DELETE FROM categorias_productos WHERE id_categoria IN (SELECT id_categoria FROM categorias WHERE nombre LIKE 'e2e_%')",
  );
  await conn.execute(
    "DELETE FROM lotes WHERE id_producto IN (SELECT id_producto FROM productos WHERE nombre LIKE 'e2e_%')",
  );
  await conn.execute("DELETE FROM productos WHERE nombre LIKE 'e2e_%'");
  await conn.execute("DELETE FROM categorias WHERE nombre LIKE 'e2e_%'");
  await conn.execute(
    "DELETE FROM configuraciones WHERE id_usuario IN (SELECT id_usuario FROM usuarios WHERE email LIKE 'e2e_%')",
  );
  await conn.execute(
    "DELETE FROM clientes WHERE nombres LIKE 'e2e_%' OR apellidos LIKE 'e2e_%'",
  );
  await conn.execute(
    "DELETE FROM auditoria WHERE id_usuario IN (SELECT id_usuario FROM usuarios WHERE email LIKE 'e2e_%')",
  );
  await conn.execute("DELETE FROM usuarios WHERE email LIKE 'e2e_%'");
  // Clean orphan users with null fields (from failed test runs)
  final orphanIds = "SELECT id_usuario FROM usuarios WHERE email IS NULL OR pin IS NULL";
  await conn.execute("DELETE FROM detalle_ventas WHERE id_venta IN (SELECT id_venta FROM ventas WHERE id_usuario IN ($orphanIds))");
  await conn.execute("DELETE FROM recibos WHERE id_venta IN (SELECT id_venta FROM ventas WHERE id_usuario IN ($orphanIds))");
  await conn.execute("DELETE FROM ventas WHERE id_usuario IN ($orphanIds)");
  await conn.execute("DELETE FROM notificaciones WHERE id_usuario IN ($orphanIds)");
  await conn.execute("DELETE FROM configuraciones WHERE id_usuario IN ($orphanIds)");
  await conn.execute("DELETE FROM auditoria WHERE id_usuario IN ($orphanIds)");
  await conn.execute("DELETE FROM usuarios WHERE email IS NULL OR pin IS NULL");

}
