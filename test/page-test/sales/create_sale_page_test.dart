import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/sales/pages/CreateSalePage.dart';
import 'package:iventi/shared/di/modules/inventory_module.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockProductoController mockProductoController;
  late MockLoteController mockLoteController;

  setUpAll(() {
    mockProductoController = MockProductoController();
    mockLoteController = MockLoteController();
    InventoryModule.productoController = mockProductoController;
    InventoryModule.loteController = mockLoteController;
  });

  setUp(() {
    reset(mockProductoController);
    reset(mockLoteController);
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/sales/create-sale',
      routes: [
        GoRoute(path: '/sales/create-sale', builder: (_, __) => const CreateSalePage()),
        GoRoute(path: '/sales/create-sale/payment', builder: (_, __) => const SizedBox()),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  group('CreateSalePage', () {
    testWidgets('debe mostrar titulo y carrito vacio', (tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.text('Crear Venta'), findsOneWidget);
    });
  });
}
