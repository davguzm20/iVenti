import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';
import 'package:iventi/features/notifications/repositories/INotificacionRepository.dart';

import '../../../mocks_mocks.dart';

final mockNotificacionRepository = MockINotificacionRepository();

NotificacionService buildService() => NotificacionService(
  mockNotificacionRepository,
  MockIProductoRepository(),
  MockILoteRepository(),
  MockIConfiguracionRepository(),
);

void main() {
  setUp(() {
    reset(mockNotificacionRepository);
  });

  group('NotificacionService.obtenerNotificaciones', () {
    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockNotificacionRepository.obtenerNotificaciones(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerNotificaciones(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al obtener notificaciones'))),
      );
    });
  });

  group('NotificacionService.contarNoLeidas', () {
    test('debe retornar cantidad de no leidas', () async {
      when(mockNotificacionRepository.contarNotificacionesNoLeidas(any))
          .thenAnswer((_) async => 5);

      final result = await buildService().contarNoLeidas(1);

      expect(result, equals(5));
    });
  });

  group('NotificacionService.eliminarNotificacion', () {
    test('debe eliminar notificacion correctamente', () async {
      when(mockNotificacionRepository.eliminarNotificacion(any))
          .thenAnswer((_) async => Future.value());

      await buildService().eliminarNotificacion(1);

      verify(mockNotificacionRepository.eliminarNotificacion(1)).called(1);
    });
  });
}
