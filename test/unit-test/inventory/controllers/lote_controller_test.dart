import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearLoteRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarLoteRequest.dart';
import 'package:iventi/features/inventory/services/LoteService.dart';
import 'package:iventi/features/inventory/controllers/LoteController.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockLoteService mockService;
  late LoteController controller;

  final lote = LoteEntity(
    idLote: 1,
    idProducto: 1,
    fechaCompra: DateTime(2024, 1, 1),
    fechaVencimiento: DateTime(2025, 12, 31),
    cantidadActual: 80,
    cantidadComprada: 100,
    cantidadPerdida: 0,
    precioCompra: 50,
    esActivo: true,
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockService = MockLoteService();
    controller = LoteController(mockService);
  });

  test('crearLote delega a LoteService', () async {
    when(mockService.crearLote(any)).thenAnswer((_) async => lote);

    final request = CrearLoteRequest(idProducto: 1, fechaCompra: DateTime(2024, 1, 1), fechaVencimiento: DateTime(2025, 12, 31), cantidadComprada: 100, precioCompra: 50);
    final result = await controller.crearLote(request);

    expect(result, lote);
    verify(mockService.crearLote(request)).called(1);
  });

  test('actualizarLote delega a LoteService', () async {
    when(mockService.actualizarLote(any)).thenAnswer((_) async => lote);

    final request = ActualizarLoteRequest(idProducto: 1, idLote: 1, cantidadActual: 90, cantidadComprada: 100, cantidadPerdida: 0, precioCompra: 50, fechaCompra: DateTime(2024, 1, 1), fechaVencimiento: DateTime(2025, 12, 31));
    final result = await controller.actualizarLote(request);

    expect(result, lote);
    verify(mockService.actualizarLote(request)).called(1);
  });

  test('eliminarLote delega a LoteService', () async {
    when(mockService.eliminarLote(1, 1)).thenAnswer((_) async => null);

    await controller.eliminarLote(1, 1);

    verify(mockService.eliminarLote(1, 1)).called(1);
  });

  test('obtenerLotePorId delega a LoteService', () async {
    when(mockService.obtenerLotePorId(1, 1)).thenAnswer((_) async => lote);

    final result = await controller.obtenerLotePorId(1, 1);

    expect(result, lote);
    verify(mockService.obtenerLotePorId(1, 1)).called(1);
  });

  test('obtenerLotesDeProducto delega a LoteService', () async {
    when(mockService.obtenerLotesDeProducto(1)).thenAnswer((_) async => [lote]);

    final result = await controller.obtenerLotesDeProducto(1);

    expect(result, [lote]);
    verify(mockService.obtenerLotesDeProducto(1)).called(1);
  });

  test('obtenerLotesPorFechas delega a LoteService', () async {
    when(mockService.obtenerLotesPorFechas(any, any)).thenAnswer((_) async => [lote]);

    final fechaInicio = DateTime(2024, 1, 1);
    final fechaFinal = DateTime(2024, 12, 31);
    final result = await controller.obtenerLotesPorFechas(fechaInicio, fechaFinal);

    expect(result, [lote]);
    verify(mockService.obtenerLotesPorFechas(fechaInicio, fechaFinal)).called(1);
  });

  test('obtenerLotesProximosAVencer delega a LoteService', () async {
    when(mockService.obtenerLotesProximosAVencer(30)).thenAnswer((_) async => [lote]);

    final result = await controller.obtenerLotesProximosAVencer(30);

    expect(result, [lote]);
    verify(mockService.obtenerLotesProximosAVencer(30)).called(1);
  });
}
