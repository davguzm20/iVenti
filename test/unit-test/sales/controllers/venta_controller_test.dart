import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';
import 'package:iventi/features/sales/services/VentaService.dart';
import 'package:iventi/features/sales/services/PagoService.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockVentaService mockVentaService;
  late MockPagoService mockPagoService;
  late VentaController controller;

  final venta = VentaEntity(
    idVenta: 1,
    idUsuario: 1,
    vendidoEn: DateTime.now(),
    montoTotal: 100,
    montoCancelado: 100,
    estado: EstadoVenta.PENDIENTE,
    esCredito: false,
    creadoEn: DateTime.now(),
  );

  setUp(() {
    mockVentaService = MockVentaService();
    mockPagoService = MockPagoService();
    controller = VentaController(mockVentaService, mockPagoService);
  });

  test('crearVenta delega a VentaService', () async {
    when(mockVentaService.crearVenta(any)).thenAnswer((_) async => venta);

    final request = CrearVentaRequest(
      idUsuario: 1, montoTotal: 100, montoCancelado: 100, esCredito: false,
      detalles: [
        DetalleVentaRequest(idProducto: 1, idLote: 1, cantidad: 2, precioUnitario: 50, subtotal: 100, ganancia: 20, descuento: 0),
      ],
    );
    final result = await controller.crearVenta(request);

    expect(result, venta);
    verify(mockVentaService.crearVenta(request)).called(1);
  });

  test('obtenerVentaPorId delega a VentaService', () async {
    when(mockVentaService.obtenerVentaPorId(1)).thenAnswer((_) async => venta);

    final result = await controller.obtenerVentaPorId(1);

    expect(result, venta);
    verify(mockVentaService.obtenerVentaPorId(1)).called(1);
  });

  test('obtenerVentasFiltradas delega a VentaService', () async {
    when(mockVentaService.obtenerVentasFiltradas(
      limite: 10, offset: 0,
      esAlContado: anyNamed('esAlContado'),
      fechaInicio: anyNamed('fechaInicio'),
      fechaFinal: anyNamed('fechaFinal'),
    )).thenAnswer((_) async => [venta]);

    final result = await controller.obtenerVentasFiltradas(limite: 10, offset: 0);

    expect(result, [venta]);
    verify(mockVentaService.obtenerVentasFiltradas(limite: 10, offset: 0)).called(1);
  });

  test('obtenerVentasDeCliente delega a VentaService', () async {
    when(mockVentaService.obtenerVentasDeCliente(1)).thenAnswer((_) async => [venta]);

    final result = await controller.obtenerVentasDeCliente(1);

    expect(result, [venta]);
    verify(mockVentaService.obtenerVentasDeCliente(1)).called(1);
  });

  test('obtenerVentasPorFechas delega a VentaService', () async {
    final inicio = DateTime(2024, 1, 1);
    final fin = DateTime(2024, 12, 31);
    when(mockVentaService.obtenerVentasPorFechas(inicio, fin)).thenAnswer((_) async => [venta]);

    final result = await controller.obtenerVentasPorFechas(inicio, fin);

    expect(result, [venta]);
    verify(mockVentaService.obtenerVentasPorFechas(inicio, fin)).called(1);
  });

  test('obtenerDetallesDeVenta delega a VentaService', () async {
    final detalle = DetalleVentaEntity(
      idVenta: 1, idLote: 1, cantidad: 2,
      precioUnitario: 50, subtotal: 100, descuento: 0, creadoEn: DateTime.now(),
    );
    when(mockVentaService.obtenerDetallesDeVenta(1)).thenAnswer((_) async => [detalle]);

    final result = await controller.obtenerDetallesDeVenta(1);

    expect(result, [detalle]);
    verify(mockVentaService.obtenerDetallesDeVenta(1)).called(1);
  });

  test('anularVenta delega a VentaService', () async {
    when(mockVentaService.anularVenta(1)).thenAnswer((_) async => null);

    await controller.anularVenta(1);

    verify(mockVentaService.anularVenta(1)).called(1);
  });

  test('registrarPago delega a PagoService', () async {
    final recibo = ReciboEntity(
      idRecibo: 1, idVenta: 1, idUsuario: 1,
      montoCancelado: 50, pagadoEn: DateTime.now(), creadoEn: DateTime.now(),
    );
    when(mockPagoService.registrarPago(1, 50.0, 1)).thenAnswer((_) async => recibo);

    final result = await controller.registrarPago(1, 50.0, 1);

    expect(result, recibo);
    verify(mockPagoService.registrarPago(1, 50.0, 1)).called(1);
  });

  test('registrarPagoCliente delega a PagoService', () async {
    when(mockPagoService.registrarPagoCliente(1, 100.0, 1)).thenAnswer((_) async => null);

    await controller.registrarPagoCliente(1, 100.0, 1);

    verify(mockPagoService.registrarPagoCliente(1, 100.0, 1)).called(1);
  });

  test('obtenerRecibosDeVenta delega a PagoService', () async {
    final recibo = ReciboEntity(
      idRecibo: 1, idVenta: 1, idUsuario: 1,
      montoCancelado: 50, pagadoEn: DateTime.now(), creadoEn: DateTime.now(),
    );
    when(mockPagoService.obtenerRecibosDeVenta(1)).thenAnswer((_) async => [recibo]);

    final result = await controller.obtenerRecibosDeVenta(1);

    expect(result, [recibo]);
    verify(mockPagoService.obtenerRecibosDeVenta(1)).called(1);
  });

  test('obtenerCantidadVendidaPorLote delega a VentaService', () async {
    when(mockVentaService.obtenerCantidadVendidaPorLote(1)).thenAnswer((_) async => 5);

    final result = await controller.obtenerCantidadVendidaPorLote(1);

    expect(result, 5);
    verify(mockVentaService.obtenerCantidadVendidaPorLote(1)).called(1);
  });
}
