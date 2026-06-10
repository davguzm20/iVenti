import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/notifications/widgets/NotificationCard.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';

void main() {
  group('NotificationCard', () {
    final now = DateTime.now();

    NotificacionEntity createNotification({
      TipoNotificacion tipo = TipoNotificacion.STOCK_BAJO,
      bool leida = false,
      DateTime? creadoEn,
    }) {
      return NotificacionEntity(
        idNotificacion: 1,
        idUsuario: 1,
        tipo: tipo,
        titulo: 'Notificación de prueba',
        contenido: 'Este es el contenido de la notificación para pruebas',
        leida: leida,
        creadoEn: creadoEn ?? now,
      );
    }

    group('renderizado', () {
      testWidgets('debe renderizar correctamente con notificacion no leida', (WidgetTester tester) async {
        final notif = createNotification();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(notification: notif),
            ),
          ),
        );

        expect(find.byType(NotificationCard), findsOneWidget);
        expect(find.text('Notificación de prueba'), findsOneWidget);
        expect(find.text('Este es el contenido de la notificación para pruebas'), findsOneWidget);
      });

      testWidgets('debe mostrar indicador de no leido cuando leida es false', (WidgetTester tester) async {
        final notif = createNotification(leida: false);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(notification: notif),
            ),
          ),
        );

        expect(find.textContaining('Ahora'), findsOneWidget);
      });

      testWidgets('debe mostrar formato de fecha para notificaciones antiguas', (WidgetTester tester) async {
        final fechaAntigua = DateTime(2024, 1, 15);
        final notif = createNotification(creadoEn: fechaAntigua);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(notification: notif),
            ),
          ),
        );

        expect(find.text('15/1/2024'), findsOneWidget);
      });

      testWidgets('debe mostrar icono segun el tipo de notificacion', (WidgetTester tester) async {
        final notif = createNotification(tipo: TipoNotificacion.STOCK_BAJO);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(notification: notif),
            ),
          ),
        );

        expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
      });
    });

    group('interaccion', () {
      testWidgets('debe llamar a onTap cuando se presiona la card', (WidgetTester tester) async {
        bool tapped = false;
        final notif = createNotification();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(
                notification: notif,
                onTap: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(NotificationCard));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('debe mostrar boton de marcar como leido cuando onMarkAsRead esta definido y no esta leida', (WidgetTester tester) async {
        final notif = createNotification(leida: false);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(
                notification: notif,
                onMarkAsRead: () {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.done), findsOneWidget);
      });

      testWidgets('debe llamar a onMarkAsRead cuando se presiona el boton de marcar como leido', (WidgetTester tester) async {
        bool marked = false;
        final notif = createNotification(leida: false);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(
                notification: notif,
                onMarkAsRead: () => marked = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.done));
        await tester.pump();

        expect(marked, isTrue);
      });

      testWidgets('debe llamar a onDelete cuando se presiona el boton de eliminar', (WidgetTester tester) async {
        bool deleted = false;
        final notif = createNotification();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(
                notification: notif,
                onDelete: () => deleted = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pump();

        expect(deleted, isTrue);
      });
    });

    group('estados', () {
      testWidgets('debe ocultar boton de marcar como leido cuando la notificacion ya esta leida', (WidgetTester tester) async {
        final notif = createNotification(leida: true);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(
                notification: notif,
                onMarkAsRead: () {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.done), findsNothing);
      });

      testWidgets('debe ocultar boton de eliminar cuando onDelete es null', (WidgetTester tester) async {
        final notif = createNotification();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationCard(notification: notif),
            ),
          ),
        );

        expect(find.byIcon(Icons.delete), findsNothing);
      });
    });
  });
}