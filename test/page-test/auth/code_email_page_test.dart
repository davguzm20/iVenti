import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/auth/pages/CodeEmailPage.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockAuthController mockAuthController;

  setUp(() {
    mockAuthController = MockAuthController();
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/code-email',
      routes: [
        GoRoute(path: '/code-email', builder: (_, __) => const CodeEmailPage(correctCode: '123456', emailUser: 'test@test.com', flujo: 'register')),
        GoRoute(path: '/login/create-pin', builder: (_, __) => const SizedBox()),
      ],
    );
    return MultiProvider(
      providers: [
        Provider<AuthController>.value(value: mockAuthController),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('CodeEmailPage', () {
    testWidgets('debe mostrar el titulo y campo de codigo', (tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.text('Ingresa el código que enviamos a tu correo'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
    });
  });
}
