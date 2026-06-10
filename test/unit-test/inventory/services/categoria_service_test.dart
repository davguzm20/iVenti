import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearCategoriaRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarCategoriaRequest.dart';
import 'package:iventi/features/inventory/services/CategoriaService.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockICategoriaRepository mockRepo;
  late CategoriaService service;

  final categoriaValida = CategoriaEntity(
    idCategoria: 1,
    nombre: 'Categoria Test',
    esActivo: true,
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockICategoriaRepository();
    service = CategoriaService(mockRepo);
  });

  group('CategoriaService.crearCategoria', () {
    test('debe crear categoria correctamente', () async {
      when(mockRepo.crearCategoria(any)).thenAnswer((_) async => categoriaValida);

      final request = CrearCategoriaRequest(nombre: 'Categoria Test');
      final result = await service.crearCategoria(request);

      expect(result, categoriaValida);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.crearCategoria(any)).thenThrow(DatabaseException('Error BD'));

      final request = CrearCategoriaRequest(nombre: 'Categoria Test');

      expect(
        () => service.crearCategoria(request),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('CategoriaService.actualizarCategoria', () {
    test('debe actualizar categoria correctamente', () async {
      when(mockRepo.editarCategoria(any)).thenAnswer((_) async => categoriaValida);

      final request = ActualizarCategoriaRequest(idCategoria: 1, nombre: 'Categoria Actualizada');
      final result = await service.actualizarCategoria(request);

      expect(result, categoriaValida);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.editarCategoria(any)).thenThrow(DatabaseException('Error BD'));

      final request = ActualizarCategoriaRequest(idCategoria: 1, nombre: 'Categoria');

      expect(
        () => service.actualizarCategoria(request),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('CategoriaService.eliminarCategoria', () {
    test('debe eliminar categoria correctamente', () async {
      when(mockRepo.eliminarCategoria(1)).thenAnswer((_) async {});

      await service.eliminarCategoria(1);

      verify(mockRepo.eliminarCategoria(1)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.eliminarCategoria(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.eliminarCategoria(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('CategoriaService.obtenerTodas', () {
    test('debe retornar lista de categorias', () async {
      when(mockRepo.obtenerCategorias()).thenAnswer((_) async => [categoriaValida]);

      final result = await service.obtenerTodas();

      expect(result, [categoriaValida]);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.obtenerCategorias()).thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerTodas(),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('CategoriaService.obtenerDeProducto', () {
    test('debe retornar categorias de un producto', () async {
      when(mockRepo.obtenerCategoriasDeProducto(1)).thenAnswer((_) async => [categoriaValida]);

      final result = await service.obtenerDeProducto(1);

      expect(result, [categoriaValida]);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.obtenerCategoriasDeProducto(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerDeProducto(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });
}
