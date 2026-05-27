import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/sales/pages/DetailsSalePage.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockVentaController mockController;

  setUp(() {
    mockController = MockVentaController();
  });

  Widget _buildTestApp() {
    final router = GoRouter(
      initialLocation: '/sales/details/1',
      routes: [
        GoRoute(path: '/sales/details/1', builder: (_, __) => const DetailsSalePage(idVenta: 1)),
      ],
    );
    return MultiProvider(
      providers: [
        Provider<VentaController>.value(value: mockController),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('DetailsSalePage', () {
    testWidgets('debe mostrar loading inicial', (tester) async {
      when(mockController.obtenerVentaPorId(1))
          .thenAnswer((_) async => null);

      await tester.pumpWidget(_buildTestApp());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debe mostrar datos de la venta y detalles', (tester) async {
      final venta = VentaEntity(
        idVenta: 1,
        idUsuario: 1,
        vendidoEn: DateTime(2025, 5, 1),
        montoTotal: 100.0,
        montoCancelado: 50.0,
        estado: EstadoVenta.PENDIENTE,
        esCredito: true,
        creadoEn: DateTime(2025, 5, 1),
      );
      final detalle = DetalleVentaEntity(
        idDetalleVenta: 1,
        idVenta: 1,
        idLote: 1,
        cantidad: 2,
        precioUnitario: 50.0,
        subtotal: 100.0,
        descuento: 0.0,
        creadoEn: DateTime(2025, 5, 1),
      );

      when(mockController.obtenerVentaPorId(1))
          .thenAnswer((_) async => venta);
      when(mockController.obtenerDetallesDeVenta(1))
          .thenAnswer((_) async => [detalle]);

      await tester.pumpWidget(_buildTestApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Detalles'), findsOneWidget);
      expect(find.text('Tipo: Crédito'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
