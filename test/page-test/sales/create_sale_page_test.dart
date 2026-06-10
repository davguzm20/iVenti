import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/sales/pages/CreateSalePage.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';
import 'package:iventi/features/inventory/controllers/LoteController.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockProductoController mockProductoController;
  late MockLoteController mockLoteController;

  setUp(() {
    mockProductoController = MockProductoController();
    mockLoteController = MockLoteController();
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/sales/create-sale',
      routes: [
        GoRoute(path: '/sales/create-sale', builder: (_, __) => const CreateSalePage()),
        GoRoute(path: '/sales/create-sale/payment', builder: (_, __) => const SizedBox()),
      ],
    );
    return MultiProvider(
      providers: [
        Provider<ProductoController>.value(value: mockProductoController),
        Provider<LoteController>.value(value: mockLoteController),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('CreateSalePage', () {
    testWidgets('debe mostrar titulo y carrito vacio', (tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.text('Crear Venta'), findsOneWidget);
    });
  });
}
