import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/services/UnidadService.dart';
import 'package:iventi/features/inventory/controllers/UnidadController.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockUnidadService mockService;
  late UnidadController controller;

  final unidad = UnidadEntity(
    idUnidad: 1,
    nombre: 'Unidad Test',
    abreviatura: 'UNT',
    esActivo: true,
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockService = MockUnidadService();
    controller = UnidadController(mockService);
  });

  test('obtenerTodas delega a UnidadService', () async {
    when(mockService.obtenerTodas()).thenAnswer((_) async => [unidad]);

    final result = await controller.obtenerTodas();

    expect(result, [unidad]);
    verify(mockService.obtenerTodas()).called(1);
  });

  test('obtenerPorId delega a UnidadService', () async {
    when(mockService.obtenerPorId(1)).thenAnswer((_) async => unidad);

    final result = await controller.obtenerPorId(1);

    expect(result, unidad);
    verify(mockService.obtenerPorId(1)).called(1);
  });
}
