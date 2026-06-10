import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/config/services/ConfiguracionService.dart';
import 'package:iventi/features/config/entities/ConfiguracionEntity.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';

import '../../../mocks_mocks.dart';

final mockConfiguracionRepository = MockIConfiguracionRepository();

ConfiguracionService buildService() => ConfiguracionService(mockConfiguracionRepository);

void main() {
  setUp(() {
    reset(mockConfiguracionRepository);
  });

  group('ConfiguracionService.obtenerConfiguracion', () {
    test('debe retornar configuracion cuando existe', () async {
      final configuracion = ConfiguracionEntity(
        idConfiguracion: 1,
        idUsuario: 1,
        clave: 'CLAVE_TEST',
        valor: 'valor_test',
        creadoEn: DateTime.now(),
      );

      when(mockConfiguracionRepository.obtenerConfiguracion(1, 'CLAVE_TEST'))
          .thenAnswer((_) async => configuracion);

      final result = await buildService().obtenerConfiguracion(1, 'CLAVE_TEST');

      expect(result, equals(configuracion));
    });

    test('debe retornar null cuando no existe', () async {
      when(mockConfiguracionRepository.obtenerConfiguracion(any, any))
          .thenAnswer((_) async => null);

      final result = await buildService().obtenerConfiguracion(1, 'CLAVE_NO_EXISTE');

      expect(result, isNull);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockConfiguracionRepository.obtenerConfiguracion(any, any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerConfiguracion(1, 'CLAVE_TEST'),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al obtener configuracion'))),
      );
    });
  });

  group('ConfiguracionService.obtenerTodas', () {
    test('debe retornar lista de configuraciones', () async {
      final configuraciones = [
        ConfiguracionEntity(
          idConfiguracion: 1,
          idUsuario: 1,
          clave: 'CLAVE_1',
          valor: 'valor_1',
          creadoEn: DateTime.now(),
        ),
        ConfiguracionEntity(
          idConfiguracion: 2,
          idUsuario: 1,
          clave: 'CLAVE_2',
          valor: 'valor_2',
          creadoEn: DateTime.now(),
        ),
      ];

      when(mockConfiguracionRepository.obtenerTodasConfiguraciones(1))
          .thenAnswer((_) async => configuraciones);

      final result = await buildService().obtenerTodas(1);

      expect(result, equals(configuraciones));
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockConfiguracionRepository.obtenerTodasConfiguraciones(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerTodas(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al obtener configuraciones'))),
      );
    });
  });

  group('ConfiguracionService.guardarConfiguracion', () {
    test('debe guardar configuracion correctamente', () async {
      final request = CrearConfiguracionRequest(
        idUsuario: 1,
        clave: 'CLAVE_TEST',
        valor: 'valor_test',
      );

      final configuracion = ConfiguracionEntity(
        idConfiguracion: 1,
        idUsuario: 1,
        clave: 'CLAVE_TEST',
        valor: 'valor_test',
        creadoEn: DateTime.now(),
      );

      when(mockConfiguracionRepository.crearOActualizarConfiguracion(request))
          .thenAnswer((_) async => configuracion);

      final result = await buildService().guardarConfiguracion(request);

      expect(result, equals(configuracion));
      verify(mockConfiguracionRepository.crearOActualizarConfiguracion(request)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = CrearConfiguracionRequest(
        idUsuario: 1,
        clave: 'CLAVE_TEST',
        valor: 'valor_test',
      );

      when(mockConfiguracionRepository.crearOActualizarConfiguracion(request))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().guardarConfiguracion(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al guardar configuracion'))),
      );
    });
  });

  group('ConfiguracionService.eliminarConfiguracion', () {
    test('debe eliminar configuracion correctamente', () async {
      when(mockConfiguracionRepository.eliminarConfiguracion(1))
          .thenAnswer((_) async => Future.value());

      await buildService().eliminarConfiguracion(1);

      verify(mockConfiguracionRepository.eliminarConfiguracion(1)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockConfiguracionRepository.eliminarConfiguracion(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().eliminarConfiguracion(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al eliminar configuracion'))),
      );
    });
  });
}
