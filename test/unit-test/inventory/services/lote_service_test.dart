import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearLoteRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarLoteRequest.dart';
import 'package:iventi/features/inventory/services/LoteService.dart';
import 'package:iventi/features/inventory/repositories/ILoteRepository.dart';
import 'package:iventi/features/inventory/repositories/IProductoRepository.dart';
import 'package:iventi/features/sales/repositories/IVentaRepository.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockILoteRepository mockLoteRepo;
  late MockIProductoRepository mockProductoRepo;
  late MockIVentaRepository mockVentaRepo;
  late LoteService service;

  final loteValido = LoteEntity(
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

  final productoValido = ProductoEntity(
    idProducto: 1,
    idUnidad: 1,
    nombre: 'Producto Test',
    precio: 100,
    stockActual: 10,
    stockMinimo: 5,
    esActivo: true,
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockLoteRepo = MockILoteRepository();
    mockProductoRepo = MockIProductoRepository();
    mockVentaRepo = MockIVentaRepository();
    service = LoteService(mockLoteRepo, mockProductoRepo, mockVentaRepo);
  });

  group('LoteService.crearLote', () {
    test('debe crear lote correctamente', () async {
      when(mockProductoRepo.obtenerProductoPorId(1)).thenAnswer((_) async => productoValido);
      when(mockLoteRepo.crearLote(any)).thenAnswer((_) async => loteValido);

      final request = CrearLoteRequest(idProducto: 1, fechaCompra: DateTime(2024, 1, 1), fechaVencimiento: DateTime(2025, 12, 31), cantidadComprada: 100, precioCompra: 50);
      final result = await service.crearLote(request);

      expect(result, loteValido);
    });

    test('debe lanzar BusinessException cuando producto no existe', () async {
      when(mockProductoRepo.obtenerProductoPorId(1)).thenAnswer((_) async => null);

      final request = CrearLoteRequest(idProducto: 1, fechaCompra: DateTime(2024, 1, 1), fechaVencimiento: DateTime(2025, 12, 31), cantidadComprada: 100, precioCompra: 50);

      expect(
        () => service.crearLote(request),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe lanzar ValidationException cuando cantidad es menor o igual a 0', () async {
      expect(
        () => CrearLoteRequest(idProducto: 1, fechaCompra: DateTime(2024, 1, 1), fechaVencimiento: DateTime(2025, 12, 31), cantidadComprada: 0, precioCompra: 50),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('LoteService.actualizarLote', () {
    test('debe actualizar lote correctamente', () async {
      when(mockLoteRepo.obtenerLotePorId(1, 1)).thenAnswer((_) async => loteValido);
      when(mockLoteRepo.actualizarLote(any)).thenAnswer((_) async => loteValido);

      final request = ActualizarLoteRequest(idProducto: 1, idLote: 1, cantidadActual: 90, cantidadComprada: 100, cantidadPerdida: 0, precioCompra: 50, fechaCompra: DateTime(2024, 1, 1), fechaVencimiento: DateTime(2025, 12, 31));
      final result = await service.actualizarLote(request);

      expect(result, loteValido);
    });

    test('debe lanzar BusinessException cuando lote no existe', () async {
      when(mockLoteRepo.obtenerLotePorId(1, 1)).thenAnswer((_) async => null);

      final request = ActualizarLoteRequest(idProducto: 1, idLote: 1, cantidadActual: 90, cantidadComprada: 100, cantidadPerdida: 0, precioCompra: 50, fechaCompra: DateTime(2024, 1, 1), fechaVencimiento: DateTime(2025, 12, 31));

      expect(
        () => service.actualizarLote(request),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe lanzar ValidationException cuando cantidad actual es negativa', () async {
      expect(
        () => ActualizarLoteRequest(idProducto: 1, idLote: 1, cantidadActual: -10, cantidadComprada: 100, cantidadPerdida: 0, precioCompra: 50, fechaCompra: DateTime(2024, 1, 1), fechaVencimiento: DateTime(2025, 12, 31)),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('LoteService.eliminarLote', () {
    test('debe eliminar lote correctamente', () async {
      when(mockLoteRepo.obtenerLotePorId(1, 1)).thenAnswer((_) async => loteValido);
      when(mockVentaRepo.obtenerCantidadVendidaPorLote(1)).thenAnswer((_) async => 0);
      when(mockLoteRepo.eliminarLote(1, 1)).thenAnswer((_) async => null);

      await service.eliminarLote(1, 1);

      verify(mockLoteRepo.eliminarLote(1, 1)).called(1);
    });

    test('debe lanzar BusinessException cuando lote no existe', () async {
      when(mockLoteRepo.obtenerLotePorId(1, 1)).thenAnswer((_) async => null);

      expect(
        () => service.eliminarLote(1, 1),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe lanzar BusinessException cuando lote tiene ventas registradas', () async {
      when(mockLoteRepo.obtenerLotePorId(1, 1)).thenAnswer((_) async => loteValido);
      when(mockVentaRepo.obtenerCantidadVendidaPorLote(1)).thenAnswer((_) async => 5);

      expect(
        () => service.eliminarLote(1, 1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('LoteService.obtenerLotePorId', () {
    test('debe retornar lote cuando existe', () async {
      when(mockLoteRepo.obtenerLotePorId(1, 1)).thenAnswer((_) async => loteValido);

      final result = await service.obtenerLotePorId(1, 1);

      expect(result, loteValido);
    });

    test('debe retornar null cuando no existe', () async {
      when(mockLoteRepo.obtenerLotePorId(1, 1)).thenAnswer((_) async => null);

      final result = await service.obtenerLotePorId(1, 1);

      expect(result, isNull);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockLoteRepo.obtenerLotePorId(any, any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerLotePorId(1, 1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('LoteService.obtenerLotesDeProducto', () {
    test('debe retornar lista de lotes de un producto', () async {
      when(mockLoteRepo.obtenerLotesDeProducto(1)).thenAnswer((_) async => [loteValido]);

      final result = await service.obtenerLotesDeProducto(1);

      expect(result, [loteValido]);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockLoteRepo.obtenerLotesDeProducto(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerLotesDeProducto(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('LoteService.obtenerLotesPorFechas', () {
    test('debe retornar lista de lotes por rango de fechas', () async {
      when(mockLoteRepo.obtenerLotesPorFechas(any, any)).thenAnswer((_) async => [loteValido]);

      final fechaInicio = DateTime(2024, 1, 1);
      final fechaFinal = DateTime(2024, 12, 31);
      final result = await service.obtenerLotesPorFechas(fechaInicio, fechaFinal);

      expect(result, [loteValido]);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockLoteRepo.obtenerLotesPorFechas(any, any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerLotesPorFechas(DateTime(2024, 1, 1), DateTime(2024, 12, 31)),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('LoteService.obtenerLotesProximosAVencer', () {
    test('debe retornar lista de lotes proximos a vencer', () async {
      when(mockLoteRepo.obtenerLotesProximosAVencer(30)).thenAnswer((_) async => [loteValido]);

      final result = await service.obtenerLotesProximosAVencer(30);

      expect(result, [loteValido]);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockLoteRepo.obtenerLotesProximosAVencer(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerLotesProximosAVencer(30),
        throwsA(isA<BusinessException>()),
      );
    });
  });
}
