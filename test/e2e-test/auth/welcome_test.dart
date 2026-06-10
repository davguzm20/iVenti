import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';

import 'package:iventi/main.dart' as app;
import 'package:iventi/shared/utils/PostgresDatasource.dart';
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

  group('Welcome E2E', () {
    testWidgets('debe mostrar bienvenida y navegar a registro', (tester) async {
      await cleanTestData();

      await app.main(envFile: ".env.test");
      await tester.pump();
      await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
      await tester.pumpAndSettle();

      expect(find.text('Bienvenido a iVenti'), findsOneWidget);
      expect(find.text('¿Eres nuevo? Regístrate aquí'), findsOneWidget);
      expect(find.text('Ya tengo cuenta'), findsOneWidget);

      await tester.tap(find.text('¿Eres nuevo? Regístrate aquí'));
      await tester.pumpAndSettle();

      expect(find.text('Ingrese su correo electrónico'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle();

      expect(find.text('Bienvenido a iVenti'), findsOneWidget);

      await tester.tap(find.text('Ya tengo cuenta'));
      await tester.pumpAndSettle();

      expect(find.text('Ingrese su correo electrónico'), findsOneWidget);
    }, timeout: const Timeout(Duration(seconds: 60)));
  });
}
