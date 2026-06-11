import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/config/pages/ConfigPage.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/enums/TipoRol.dart';
import 'package:iventi/features/config/entities/ConfiguracionEntity.dart';
import 'package:iventi/shared/di/modules/auth_module.dart';
import 'package:iventi/shared/di/modules/config_module.dart';

import '../../mocks_mocks.dart';
import '../helpers.dart';

void main() {
  late MockAuthController mockAuthController;
  late MockConfiguracionController mockConfigController;

  setUpAll(() {
    mockAuthController = MockAuthController();
    mockConfigController = MockConfiguracionController();
    AuthModule.authController = mockAuthController;
    ConfigModule.configuracionController = mockConfigController;
  });

  setUp(() {
    reset(mockAuthController);
    reset(mockConfigController);
  });

  group('ConfigPage', () {
    testWidgets('debe mostrar loading inicial', (tester) async {
      when(mockAuthController.obtenerUsuarioRegistrado())
          .thenAnswer((_) async => UsuarioEntity(idUsuario: 1, email: 'test@test.com', nombre: 'Test', pin: '123456', rol: TipoRol.ADMINISTRADOR, creadoEn: DateTime(2025, 5, 1)));
      when(mockConfigController.obtenerTodas(1)).thenAnswer((_) async => []);

      await pumpPageWithRouter(
        tester,
        location: '/config',
        page: const ConfigPage(),
        providers: [],
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe mostrar formulario con datos cargados', (tester) async {
      when(mockAuthController.obtenerUsuarioRegistrado())
          .thenAnswer((_) async => UsuarioEntity(idUsuario: 1, email: 'test@test.com', nombre: 'Test User', pin: '123456', rol: TipoRol.ADMINISTRADOR, creadoEn: DateTime(2025, 5, 1)));
      when(mockConfigController.obtenerTodas(1)).thenAnswer((_) async => [
        ConfiguracionEntity(idConfiguracion: 1, idUsuario: 1, clave: 'dias_vencimiento', valor: '30', creadoEn: DateTime(2025, 5, 1)),
        ConfiguracionEntity(idConfiguracion: 2, idUsuario: 1, clave: 'stock_minimo_alerta', valor: '10', creadoEn: DateTime(2025, 5, 1)),
      ]);

      await pumpPageWithRouter(
        tester,
        location: '/config',
        page: const ConfigPage(),
        providers: [],
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Configuración'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.text('Alertas'), findsOneWidget);
      expect(find.text('Guardar configuración'), findsOneWidget);
    });
  });
}
