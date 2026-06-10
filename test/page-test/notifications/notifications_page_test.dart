import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/notifications/pages/NotificationsPage.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';

import '../../mocks_mocks.dart';
import '../helpers.dart';

void main() {
  late MockNotificacionController mockController;

  setUp(() {
    mockController = MockNotificacionController();
  });

  group('NotificationsPage', () {
    testWidgets('debe mostrar loading inicial', (tester) async {
      when(mockController.obtenerNotificaciones(1)).thenAnswer((_) async => []);

      await pumpPage(
        tester,
        page: const NotificationsPage(),
        providers: [
          Provider<NotificacionController>.value(value: mockController),
        ],
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe mostrar empty state cuando no hay notificaciones', (tester) async {
      when(mockController.obtenerNotificaciones(1)).thenAnswer((_) async => []);

      await pumpPage(
        tester,
        page: const NotificationsPage(),
        providers: [
          Provider<NotificacionController>.value(value: mockController),
        ],
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

      when(mockController.obtenerNotificaciones(1)).thenAnswer((_) async => [notif]);

      await pumpPage(
        tester,
        page: const NotificationsPage(),
        providers: [
          Provider<NotificacionController>.value(value: mockController),
        ],
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Stock bajo'), findsOneWidget);
    });
  });
}
