import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/auth/pages/CreatePinPage.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/enums/TipoRol.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockAuthController mockAuthController;

  setUp(() {
    mockAuthController = MockAuthController();
  });

  Widget _buildTestApp({bool isRecovery = false, String? extraEmail}) {
    final router = GoRouter(
      initialLocation: '/create-pin',
      routes: [
        GoRoute(path: '/create-pin', builder: (_, __) => CreatePinPage(isRecovery: isRecovery)),
        GoRoute(path: '/login', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/login/setup', builder: (_, __) => const SizedBox()),
      ],
    );
    if (extraEmail != null) {
      router.go('/create-pin', extra: extraEmail);
    }
    return MultiProvider(
      providers: [
        Provider<AuthController>.value(value: mockAuthController),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('CreatePinPage', () {
    testWidgets('debe mostrar titulo y campo de PIN', (tester) async {
      await tester.pumpWidget(_buildTestApp(extraEmail: 'user@test.com'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Crea un PIN de 6 dígitos para asegurar tu cuenta'), findsOneWidget);
      expect(find.text('Vuelve a ingresar el PIN para confirmar'), findsOneWidget);
      expect(find.text('Siguiente'), findsOneWidget);
    });

    testWidgets('debe mostrar email del extra', (tester) async {
      await tester.pumpWidget(_buildTestApp(extraEmail: 'user@test.com'));
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('user@test.com'), findsOneWidget);
    });

    testWidgets('debe obtener email del controller cuando no hay extra', (tester) async {
      when(mockAuthController.obtenerUsuarioRegistrado())
          .thenAnswer((_) async => UsuarioEntity(idUsuario: 1, email: 'loaded@test.com', nombre: 'Test', pin: '123456', rol: TipoRol.ADMINISTRADOR, creadoEn: DateTime(2025, 5, 1)));

      await tester.pumpWidget(_buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('loaded@test.com'), findsOneWidget);
    });
  });
}
