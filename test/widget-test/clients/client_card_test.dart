import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/clients/widgets/ClientCard.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';

void main() {
  group('ClientCard', () {
    final testClient = ClienteEntity(
      idCliente: 1,
      dni: '12345678',
      nombres: 'John',
      apellidos: 'Doe',
      email: 'john@example.com',
      telefono: '123456789',
      esDeudor: false,
      esActivo: true,
      creadoEn: DateTime.now(),
    );

    group('renderizado', () {
      testWidgets('debe renderizar correctamente con cliente completo', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: testClient,
              ),
            ),
          ),
        );

        expect(find.byType(ClientCard), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('DNI: 12345678'), findsOneWidget);
        expect(find.text('Tel: 123456789'), findsOneWidget);
        expect(find.text('john@example.com'), findsOneWidget);
      });

      testWidgets('debe mostrar etiqueta Deudor cuando esDeudor es true', (WidgetTester tester) async {
        final clientDeudor = ClienteEntity(
          idCliente: 1,
          dni: '12345678',
          nombres: 'John',
          apellidos: 'Doe',
          email: 'john@example.com',
          telefono: '123456789',
          esDeudor: true,
          esActivo: true,
          creadoEn: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: clientDeudor,
              ),
            ),
          ),
        );

        expect(find.text('Deudor'), findsOneWidget);
      });

      testWidgets('no debe mostrar DNI cuando es null', (WidgetTester tester) async {
        final clientWithoutDni = ClienteEntity(
          idCliente: 1,
          dni: null,
          nombres: 'John',
          apellidos: 'Doe',
          email: 'john@example.com',
          telefono: '123456789',
          esDeudor: false,
          esActivo: true,
          creadoEn: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: clientWithoutDni,
              ),
            ),
          ),
        );

        expect(find.text('DNI: '), findsNothing);
      });

      testWidgets('no debe mostrar telefono cuando es vacio', (WidgetTester tester) async {
        final clientWithoutPhone = ClienteEntity(
          idCliente: 1,
          dni: '12345678',
          nombres: 'John',
          apellidos: 'Doe',
          email: 'john@example.com',
          telefono: '',
          esDeudor: false,
          esActivo: true,
          creadoEn: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: clientWithoutPhone,
              ),
            ),
          ),
        );

        expect(find.text('Tel: '), findsNothing);
      });

      testWidgets('no debe mostrar email cuando es null', (WidgetTester tester) async {
        final clientWithoutEmail = ClienteEntity(
          idCliente: 1,
          dni: '12345678',
          nombres: 'John',
          apellidos: 'Doe',
          email: null,
          telefono: '123456789',
          esDeudor: false,
          esActivo: true,
          creadoEn: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: clientWithoutEmail,
              ),
            ),
          ),
        );

        expect(find.text('null'), findsNothing);
      });
    });

    group('interaccion', () {
      testWidgets('debe llamar a onTap cuando se presiona la card', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: testClient,
                onTap: () => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ClientCard));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('debe llamar a onViewDetail cuando se presiona el boton de ver', (WidgetTester tester) async {
        bool viewed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: testClient,
                onViewDetail: () => viewed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump();

        expect(viewed, isTrue);
      });

      testWidgets('debe llamar a onEdit cuando se presiona el boton de editar', (WidgetTester tester) async {
        bool edited = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: testClient,
                onEdit: () => edited = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.edit));
        await tester.pump();

        expect(edited, isTrue);
      });

      testWidgets('debe llamar a onDelete cuando se presiona el boton de eliminar', (WidgetTester tester) async {
        bool deleted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: testClient,
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
      testWidgets('debe mostrar botones de acciones cuando los callbacks estan definidos', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: testClient,
                onViewDetail: () {},
                onEdit: () {},
                onDelete: () {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.visibility), findsOneWidget);
        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('no debe mostrar botones de acciones cuando los callbacks son null', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClientCard(
                client: testClient,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.visibility), findsNothing);
        expect(find.byIcon(Icons.edit), findsNothing);
        expect(find.byIcon(Icons.delete), findsNothing);
      });
    });
  });
}