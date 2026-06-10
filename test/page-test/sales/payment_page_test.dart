import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/sales/pages/PaymentPage.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockVentaController mockVentaController;
  late MockClienteController mockClienteController;

  setUp(() {
    mockVentaController = MockVentaController();
    mockClienteController = MockClienteController();
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/sales/payment',
      routes: [
        GoRoute(path: '/sales/payment', builder: (_, __) => const PaymentPage(detallesVenta: [
          {'subtotalProducto': 100.0, 'idProducto': 1, 'idLote': 1, 'nombre': 'Producto', 'precio': 100.0, 'cantidad': 1, 'precioUnidadProducto': 100.0, 'descuentoProducto': 0.0, 'gananciaProducto': 20.0, 'cantidadProducto': 1},
        ])),
        GoRoute(path: '/sales', builder: (_, __) => const SizedBox()),
      ],
    );
    return MultiProvider(
      providers: [
        Provider<VentaController>.value(value: mockVentaController),
        Provider<ClienteController>.value(value: mockClienteController),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
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
