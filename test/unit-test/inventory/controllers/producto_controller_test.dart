import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarProductoRequest.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockProductoService mockService;
  late ProductoController controller;

  final producto = ProductoEntity(
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
    mockService = MockProductoService();
    controller = ProductoController(mockService);
  });

  test('crearProducto delega a ProductoService', () async {
    when(mockService.crearProducto(any, idCategorias: anyNamed('idCategorias'))).thenAnswer((_) async => producto);

    final request = CrearProductoRequest(idUnidad: 1, nombre: 'Producto Test', precio: 100, stockMinimo: 5);
    final result = await controller.crearProducto(request);

    expect(result, producto);
    verify(mockService.crearProducto(request, idCategorias: null)).called(1);
  });

  test('actualizarProducto delega a ProductoService', () async {
    when(mockService.actualizarProducto(any, idCategorias: anyNamed('idCategorias'))).thenAnswer((_) async => producto);

    final request = ActualizarProductoRequest(idProducto: 1, idUnidad: 1, nombre: 'Producto Actualizado', precio: 150, stockMinimo: 5);
    final result = await controller.actualizarProducto(request);

    expect(result, producto);
    verify(mockService.actualizarProducto(request, idCategorias: null)).called(1);
  });

  test('eliminarProducto delega a ProductoService', () async {
    when(mockService.eliminarProducto(1)).thenAnswer((_) async {});

    await controller.eliminarProducto(1);

    verify(mockService.eliminarProducto(1)).called(1);
  });

  test('obtenerProductoPorId delega a ProductoService', () async {
    when(mockService.obtenerProductoPorId(1)).thenAnswer((_) async => producto);

    final result = await controller.obtenerProductoPorId(1);

    expect(result, producto);
    verify(mockService.obtenerProductoPorId(1)).called(1);
  });

  test('obtenerProductoPorCodigo delega a ProductoService', () async {
    when(mockService.obtenerProductoPorCodigo('COD001')).thenAnswer((_) async => producto);

    final result = await controller.obtenerProductoPorCodigo('COD001');

    expect(result, producto);
    verify(mockService.obtenerProductoPorCodigo('COD001')).called(1);
  });

  test('buscarPorNombre delega a ProductoService', () async {
    when(mockService.buscarPorNombre('Producto')).thenAnswer((_) async => [producto]);

    final result = await controller.buscarPorNombre('Producto');

    expect(result, [producto]);
    verify(mockService.buscarPorNombre('Producto')).called(1);
  });

  test('obtenerTodos delega a ProductoService', () async {
    when(mockService.obtenerTodos()).thenAnswer((_) async => [producto]);

    final result = await controller.obtenerTodos();

    expect(result, [producto]);
    verify(mockService.obtenerTodos()).called(1);
  });

  test('obtenerFiltrados delega a ProductoService', () async {
    when(mockService.obtenerFiltrados(limite: 10, offset: 0, idCategorias: anyNamed('idCategorias'), stockBajo: anyNamed('stockBajo')))
        .thenAnswer((_) async => [producto]);

    final result = await controller.obtenerFiltrados(limite: 10, offset: 0);

    expect(result, [producto]);
    verify(mockService.obtenerFiltrados(limite: 10, offset: 0, idCategorias: null, stockBajo: null)).called(1);
  });
}
