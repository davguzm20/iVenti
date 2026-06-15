import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/notifications/pages/NotificationsPage.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';

import '../module_setup.dart';
import '../helpers.dart';

void main() {
  setUpAll(() {
    setupModuleMocks();
    ServiceLocator.usuarioActualId = 1;
  });

  setUp(() {
    resetModuleMocks();
  });

  group('NotificationsPage', () {
    testWidgets('debe mostrar loading inicial', (tester) async {
      when(mockNotificacionController.obtenerNotificaciones(1)).thenAnswer((_) async => []);

      await pumpPage(
        tester,
        page: const NotificationsPage(),
        providers: [],
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe mostrar empty state cuando no hay notificaciones', (tester) async {
      when(mockNotificacionController.obtenerNotificaciones(1)).thenAnswer((_) async => []);

      await pumpPage(
        tester,
        page: const NotificationsPage(),
        providers: [],
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('No hay notificaciones'), findsOneWidget);
    });

    testWidgets('debe mostrar lista de notificaciones', (tester) async {
      final notif = NotificacionEntity(
        idNotificacion: 1,
        idUsuario: 1,
        tipo: TipoNotificacion.STOCK_BAJO,
        titulo: 'Stock bajo',
        contenido: 'El producto X tiene stock bajo',
        leida: false,
        creadoEn: DateTime(2025, 5, 1),
      );

      when(mockNotificacionController.obtenerNotificaciones(1)).thenAnswer((_) async => [notif]);

      await pumpPage(
        tester,
        page: const NotificationsPage(),
        providers: [],
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Stock bajo'), findsOneWidget);
    });
  });
}
