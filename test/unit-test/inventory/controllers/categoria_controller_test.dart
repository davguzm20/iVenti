import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearCategoriaRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarCategoriaRequest.dart';
import 'package:iventi/features/inventory/services/CategoriaService.dart';
import 'package:iventi/features/inventory/controllers/CategoriaController.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockCategoriaService mockService;
  late CategoriaController controller;

  final categoria = CategoriaEntity(
    idCategoria: 1,
    nombre: 'Categoria Test',
    esActivo: true,
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockService = MockCategoriaService();
    controller = CategoriaController(mockService);
  });

  test('crearCategoria delega a CategoriaService', () async {
    when(mockService.crearCategoria(any)).thenAnswer((_) async => categoria);

    final request = CrearCategoriaRequest(nombre: 'Categoria Test');
    final result = await controller.crearCategoria(request);

    expect(result, categoria);
    verify(mockService.crearCategoria(request)).called(1);
  });

  test('actualizarCategoria delega a CategoriaService', () async {
    when(mockService.actualizarCategoria(any)).thenAnswer((_) async => categoria);

    final request = ActualizarCategoriaRequest(idCategoria: 1, nombre: 'Categoria Actualizada');
    final result = await controller.actualizarCategoria(request);

    expect(result, categoria);
    verify(mockService.actualizarCategoria(request)).called(1);
  });

  test('eliminarCategoria delega a CategoriaService', () async {
    when(mockService.eliminarCategoria(1)).thenAnswer((_) async => null);

    await controller.eliminarCategoria(1);

    verify(mockService.eliminarCategoria(1)).called(1);
  });

  test('obtenerTodas delega a CategoriaService', () async {
    when(mockService.obtenerTodas()).thenAnswer((_) async => [categoria]);

    final result = await controller.obtenerTodas();

    expect(result, [categoria]);
    verify(mockService.obtenerTodas()).called(1);
  });

  test('obtenerDeProducto delega a CategoriaService', () async {
    when(mockService.obtenerDeProducto(1)).thenAnswer((_) async => [categoria]);

    final result = await controller.obtenerDeProducto(1);

    expect(result, [categoria]);
    verify(mockService.obtenerDeProducto(1)).called(1);
  });
}
