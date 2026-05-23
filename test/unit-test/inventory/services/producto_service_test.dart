import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarProductoRequest.dart';
import 'package:iventi/features/inventory/services/ProductoService.dart';
import 'package:iventi/features/inventory/repositories/IProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/ICategoriaRepository.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockIProductoRepository mockProductoRepo;
  late MockICategoriaRepository mockCategoriaRepo;
  late ProductoService service;

  final productoValido = ProductoEntity(
    idProducto: 1,
    idUnidad: 1,
    codigo: 'COD001',
    nombre: 'Producto Test',
    precio: 100,
    stockActual: 10,
    stockMinimo: 5,
    esActivo: true,
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockProductoRepo = MockIProductoRepository();
    mockCategoriaRepo = MockICategoriaRepository();
    service = ProductoService(mockProductoRepo, mockCategoriaRepo);
  });

  group('ProductoService.crearProducto', () {
    test('debe crear producto cuando codigo no existe', () async {
      when(mockProductoRepo.obtenerProductoPorCodigo(any)).thenAnswer((_) async => null);
      when(mockProductoRepo.crearProducto(any)).thenAnswer((_) async => productoValido);

      final request = CrearProductoRequest(idUnidad: 1, nombre: 'Producto Test', precio: 100, stockMinimo: 5);
      final result = await service.crearProducto(request);

      expect(result, productoValido);
    });

    test('debe lanzar BusinessException cuando codigo ya existe', () async {
      when(mockProductoRepo.obtenerProductoPorCodigo(any)).thenAnswer((_) async => productoValido);

      final request = CrearProductoRequest(idUnidad: 1, codigo: 'COD001', nombre: 'Producto Test', precio: 100, stockMinimo: 5);

      expect(
        () => service.crearProducto(request),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockProductoRepo.obtenerProductoPorCodigo(any)).thenAnswer((_) async => null);
      when(mockProductoRepo.crearProducto(any)).thenThrow(DatabaseException('Error BD'));

      final request = CrearProductoRequest(idUnidad: 1, nombre: 'Producto Test', precio: 100, stockMinimo: 5);

      expect(
        () => service.crearProducto(request),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ProductoService.actualizarProducto', () {
    test('debe actualizar producto cuando existe', () async {
      when(mockProductoRepo.obtenerProductoPorId(1)).thenAnswer((_) async => productoValido);
      when(mockProductoRepo.actualizarProducto(any)).thenAnswer((_) async => productoValido);

      final request = ActualizarProductoRequest(idProducto: 1, idUnidad: 1, nombre: 'Producto Actualizado', precio: 150, stockMinimo: 5);
      final result = await service.actualizarProducto(request);

      expect(result, productoValido);
    });

    test('debe lanzar BusinessException cuando producto no existe', () async {
      when(mockProductoRepo.obtenerProductoPorId(999)).thenAnswer((_) async => null);

      final request = ActualizarProductoRequest(idProducto: 999, idUnidad: 1, nombre: 'Producto', precio: 100, stockMinimo: 5);

      expect(
        () => service.actualizarProducto(request),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ProductoService.eliminarProducto', () {
    test('debe eliminar producto cuando existe', () async {
      when(mockProductoRepo.obtenerProductoPorId(1)).thenAnswer((_) async => productoValido);
      when(mockProductoRepo.eliminarProducto(1)).thenAnswer((_) async => null);

      await service.eliminarProducto(1);

      verify(mockProductoRepo.eliminarProducto(1)).called(1);
    });

    test('debe lanzar BusinessException cuando producto no existe', () async {
      when(mockProductoRepo.obtenerProductoPorId(999)).thenAnswer((_) async => null);

      expect(
        () => service.eliminarProducto(999),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ProductoService.obtenerProductoPorId', () {
    test('debe retornar producto cuando existe', () async {
      when(mockProductoRepo.obtenerProductoPorId(1)).thenAnswer((_) async => productoValido);

      final result = await service.obtenerProductoPorId(1);

      expect(result, productoValido);
    });

    test('debe retornar null cuando no existe', () async {
      when(mockProductoRepo.obtenerProductoPorId(999)).thenAnswer((_) async => null);

      final result = await service.obtenerProductoPorId(999);

      expect(result, isNull);
    });
  });

  group('ProductoService.obtenerProductoPorCodigo', () {
    test('debe retornar producto cuando existe', () async {
      when(mockProductoRepo.obtenerProductoPorCodigo('COD001')).thenAnswer((_) async => productoValido);

      final result = await service.obtenerProductoPorCodigo('COD001');

      expect(result, productoValido);
    });

    test('debe retornar null cuando no existe', () async {
      when(mockProductoRepo.obtenerProductoPorCodigo('COD999')).thenAnswer((_) async => null);

      final result = await service.obtenerProductoPorCodigo('COD999');

      expect(result, isNull);
    });
  });

  group('ProductoService.buscarPorNombre', () {
    test('debe retornar lista de productos', () async {
      when(mockProductoRepo.obtenerProductosPorNombre('Producto')).thenAnswer((_) async => [productoValido]);

      final result = await service.buscarPorNombre('Producto');

      expect(result, [productoValido]);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockProductoRepo.obtenerProductosPorNombre(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.buscarPorNombre('Producto'),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ProductoService.obtenerTodos', () {
    test('debe retornar lista de todos los productos', () async {
      when(mockProductoRepo.obtenerTodosLosProductos()).thenAnswer((_) async => [productoValido]);

      final result = await service.obtenerTodos();

      expect(result, [productoValido]);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockProductoRepo.obtenerTodosLosProductos())
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerTodos(),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ProductoService.obtenerFiltrados', () {
    test('debe retornar productos filtrados', () async {
      when(mockProductoRepo.obtenerProductosPorFiltros(
        limite: 10, offset: 0, idCategorias: anyNamed('idCategorias'), stockBajo: anyNamed('stockBajo'),
      )).thenAnswer((_) async => [productoValido]);

      final result = await service.obtenerFiltrados(limite: 10, offset: 0);

      expect(result, [productoValido]);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockProductoRepo.obtenerProductosPorFiltros(
        limite: anyNamed('limite'), offset: anyNamed('offset'),
        idCategorias: anyNamed('idCategorias'), stockBajo: anyNamed('stockBajo'),
      )).thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerFiltrados(limite: 10, offset: 0),
        throwsA(isA<BusinessException>()),
      );
    });
  });
}
