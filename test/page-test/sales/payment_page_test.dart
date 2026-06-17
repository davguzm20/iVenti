import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/sales/pages/PaymentPage.dart';
import 'package:iventi/shared/di/modules/sales_module.dart';
import 'package:iventi/shared/di/modules/clients_module.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockVentaController mockVentaController;
  late MockClienteController mockClienteController;

  setUpAll(() {
    mockVentaController = MockVentaController();
    mockClienteController = MockClienteController();
    SalesModule.ventaController = mockVentaController;
    ClienteModule.clienteController = mockClienteController;
    ServiceLocator.usuarioActualId = 1;
  });

  setUp(() {
    reset(mockVentaController);
    reset(mockClienteController);
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/sales/payment',
      routes: [
        GoRoute(path: '/sales/payment', builder: (_, __) => const PaymentPage(detallesVenta: [
          {'subtotalProducto': 100.0, 'idProducto': 1, 'idLote': 1, 'nombre': 'Producto', 'precio': 100.0, 'cantidad': 1, 'precioUnidadProducto': 100.0, 'descuentoProducto': 0.0, 'cantidadProducto': 1},
        ])),
        GoRoute(path: '/sales', builder: (_, __) => const SizedBox()),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  group('PaymentPage', () {
    testWidgets('debe mostrar formulario de pago', (tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.text('Pago'), findsOneWidget);
      expect(find.text('Crear Cliente'), findsOneWidget);
      expect(find.text('Buscar Cliente'), findsOneWidget);
      expect(find.text('Al contado'), findsOneWidget);
      expect(find.text('Crédito'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
    });
  });
}
