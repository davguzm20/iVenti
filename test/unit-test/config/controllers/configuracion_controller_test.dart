import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';
import 'package:iventi/features/config/entities/ConfiguracionEntity.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';

import '../../../mocks_mocks.dart';

final mockConfiguracionService = MockConfiguracionService();

ConfiguracionController buildController() => ConfiguracionController(mockConfiguracionService);

void main() {
  setUp(() {
    reset(mockConfiguracionService);
  });

  group('ConfiguracionController.obtenerConfiguracion', () {
    test('delega a ConfiguracionService', () async {
      final configuracion = ConfiguracionEntity(
        idConfiguracion: 1,
        idUsuario: 1,
        clave: 'CLAVE_TEST',
        valor: 'valor_test',
        creadoEn: DateTime.now(),
      );

      when(mockConfiguracionService.obtenerConfiguracion(1, 'CLAVE_TEST'))
          .thenAnswer((_) async => configuracion);

      final result = await buildController().obtenerConfiguracion(1, 'CLAVE_TEST');

      expect(result, equals(configuracion));
      verify(mockConfiguracionService.obtenerConfiguracion(1, 'CLAVE_TEST')).called(1);
    });
  });

  group('ConfiguracionController.obtenerTodas', () {
    test('delega a ConfiguracionService', () async {
      final configuraciones = [
        ConfiguracionEntity(
          idConfiguracion: 1,
          idUsuario: 1,
          clave: 'CLAVE_1',
          valor: 'valor_1',
          creadoEn: DateTime.now(),
        ),
      ];

      when(mockConfiguracionService.obtenerTodas(1))
          .thenAnswer((_) async => configuraciones);

      final result = await buildController().obtenerTodas(1);

      expect(result, equals(configuraciones));
      verify(mockConfiguracionService.obtenerTodas(1)).called(1);
    });
  });

  group('ConfiguracionController.guardarConfiguracion', () {
    test('delega a ConfiguracionService', () async {
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

      when(mockConfiguracionService.guardarConfiguracion(request))
          .thenAnswer((_) async => configuracion);

      final result = await buildController().guardarConfiguracion(request);

      expect(result, equals(configuracion));
      verify(mockConfiguracionService.guardarConfiguracion(request)).called(1);
    });
  });

  group('ConfiguracionController.eliminarConfiguracion', () {
    test('delega a ConfiguracionService', () async {
      when(mockConfiguracionService.eliminarConfiguracion(1))
          .thenAnswer((_) async => Future.value());

      await buildController().eliminarConfiguracion(1);

      verify(mockConfiguracionService.eliminarConfiguracion(1)).called(1);
    });
  });
}
