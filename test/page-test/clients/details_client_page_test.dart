import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/clients/pages/DetailsClientPage.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';
import 'package:iventi/shared/di/modules/clients_module.dart';
import 'package:iventi/shared/di/modules/sales_module.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockClienteController mockClienteController;
  late MockVentaController mockVentaController;

  setUpAll(() {
    mockClienteController = MockClienteController();
    mockVentaController = MockVentaController();
    ClienteModule.clienteController = mockClienteController;
    SalesModule.ventaController = mockVentaController;
  });

  setUp(() {
    reset(mockClienteController);
    reset(mockVentaController);
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/clients/details/1',
      routes: [
        GoRoute(path: '/clients/details/1', builder: (_, __) => const DetailsClientPage(idCliente: 1)),
        GoRoute(path: '/sales/details-sale/:id', builder: (_, __) => const SizedBox()),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  group('DetailsClientPage', () {
    testWidgets('debe mostrar placeholder cuando el cliente es nulo', (tester) async {
      when(mockClienteController.obtenerClientePorId(1))
          .thenAnswer((_) async => null);
      when(mockVentaController.obtenerVentasDeCliente(1))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('---'), findsWidgets);
    });

    testWidgets('debe mostrar datos del cliente y ventas vacias', (tester) async {
      when(mockClienteController.obtenerClientePorId(1))
          .thenAnswer((_) async => ClienteEntity(idCliente: 1, nombres: 'Juan', dni: '12345678', email: 'juan@test.com', telefono: '999888777', esDeudor: false, creadoEn: DateTime(2025, 5, 1)));
      when(mockVentaController.obtenerVentasDeCliente(1))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('ID Cliente: 1'), findsOneWidget);
      expect(find.text('DNI: 12345678'), findsOneWidget);
      expect(find.text('Email: juan@test.com'), findsOneWidget);
      expect(find.text('Teléfono: 999888777'), findsOneWidget);
      expect(find.text('REGULAR'), findsOneWidget);
      expect(find.text('No se encontraron ventas'), findsOneWidget);
    });

    testWidgets('debe mostrar ventas del cliente', (tester) async {
      when(mockClienteController.obtenerClientePorId(1))
          .thenAnswer((_) async => ClienteEntity(idCliente: 1, nombres: 'Juan', esDeudor: true, creadoEn: DateTime(2025, 5, 1)));
      when(mockVentaController.obtenerVentasDeCliente(1))
          .thenAnswer((_) async => [
            VentaEntity(idVenta: 1, idUsuario: 1, vendidoEn: DateTime(2025, 5, 1), montoTotal: 100.0, montoCancelado: 50.0, estado: EstadoVenta.PENDIENTE, esCredito: true, creadoEn: DateTime(2025, 5, 1)),
          ]);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Venta 1'), findsOneWidget);
      expect(find.text('Tipo: Crédito'), findsOneWidget);
    });
  });
}
