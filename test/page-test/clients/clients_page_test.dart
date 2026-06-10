import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/clients/pages/ClientsPage.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockClienteController mockController;

  setUp(() {
    mockController = MockClienteController();
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/clients',
      routes: [
        GoRoute(path: '/clients', builder: (_, __) => const ClientsPage()),
        GoRoute(path: '/clients/details-client/:id', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/clients/filter-clients', builder: (_, __) => const SizedBox()),
      ],
    );
    return MultiProvider(
      providers: [
        Provider<ClienteController>.value(value: mockController),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('ClientsPage', () {
    testWidgets('debe mostrar loading inicial', (tester) async {
      when(mockController.obtenerFiltrados(limite: 50, offset: 0, esDeudor: anyNamed('esDeudor')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe mostrar empty state cuando no hay clientes', (tester) async {
      when(mockController.obtenerFiltrados(limite: 50, offset: 0, esDeudor: anyNamed('esDeudor')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('No se encontraron clientes'), findsOneWidget);
    });

    testWidgets('debe mostrar lista de clientes', (tester) async {
      final cliente = ClienteEntity(
        idCliente: 1,
        nombres: 'Juan',
        apellidos: 'Pérez',
        esDeudor: false,
        creadoEn: DateTime(2025, 5, 1),
      );

      when(mockController.obtenerFiltrados(limite: 50, offset: 0, esDeudor: anyNamed('esDeudor')))
          .thenAnswer((_) async => [cliente]);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Juan Pérez'), findsOneWidget);
    });
  });
}
