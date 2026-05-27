import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/services/UnidadService.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockIUnidadRepository mockRepo;
  late UnidadService service;

  final unidadValida = UnidadEntity(
    idUnidad: 1,
    nombre: 'Unidad Test',
    abreviatura: 'UNT',
    esActivo: true,
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockIUnidadRepository();
    service = UnidadService(mockRepo);
  });

  group('UnidadService.obtenerTodas', () {
    test('debe retornar lista de unidades', () async {
      when(mockRepo.obtenerUnidades()).thenAnswer((_) async => [unidadValida]);

      final result = await service.obtenerTodas();

      expect(result, [unidadValida]);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.obtenerUnidades()).thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerTodas(),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('UnidadService.obtenerPorId', () {
    test('debe retornar unidad cuando existe', () async {
      when(mockRepo.obtenerUnidadPorId(1)).thenAnswer((_) async => unidadValida);

      final result = await service.obtenerPorId(1);

      expect(result, unidadValida);
    });

    test('debe retornar null cuando no existe', () async {
      when(mockRepo.obtenerUnidadPorId(999)).thenAnswer((_) async => null);

      final result = await service.obtenerPorId(999);

      expect(result, isNull);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.obtenerUnidadPorId(1)).thenThrow(DatabaseException('Error BD'));

      expect(
        () => service.obtenerPorId(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });
}
