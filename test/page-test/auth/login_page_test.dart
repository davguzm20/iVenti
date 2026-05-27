import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/auth/pages/LoginPage.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/enums/TipoRol.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockAuthController mockAuthController;

  setUp(() {
    mockAuthController = MockAuthController();
  });

  Widget _buildTestApp({String? extraEmail}) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/inventory', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/login/recover-pin', builder: (_, __) => const SizedBox()),
      ],
    );
    if (extraEmail != null) {
      router.go('/login', extra: extraEmail);
    }
    return MultiProvider(
      providers: [
        Provider<AuthController>.value(value: mockAuthController),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('LoginPage', () {
    testWidgets('debe mostrar loading cuando no hay email cargado', (tester) async {
      when(mockAuthController.obtenerUsuarioRegistrado())
          .thenAnswer((_) async => UsuarioEntity(idUsuario: 1, email: 'test@test.com', nombre: 'Test', pin: '123456', rol: TipoRol.ADMINISTRADOR, creadoEn: DateTime(2025, 5, 1)));

      await tester.pumpWidget(_buildTestApp());
      await tester.pump();

      expect(find.text('Iniciar sesión'), findsOneWidget);
    });

    testWidgets('debe mostrar email del GoRouter extra', (tester) async {
      await tester.pumpWidget(_buildTestApp(extraEmail: 'extra@email.com'));
      await tester.pump();
      await tester.pump();

      expect(find.text('extra@email.com'), findsOneWidget);
    });

    testWidgets('debe mostrar boton de ingresar y olvidaste PIN', (tester) async {
      when(mockAuthController.obtenerUsuarioRegistrado())
          .thenAnswer((_) async => UsuarioEntity(idUsuario: 1, email: 'test@test.com', nombre: 'Test', pin: '123456', rol: TipoRol.ADMINISTRADOR, creadoEn: DateTime(2025, 5, 1)));

      await tester.pumpWidget(_buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Ingresar'), findsOneWidget);
      expect(find.text('¿Olvidaste tu PIN?'), findsOneWidget);
    });
  });
}
