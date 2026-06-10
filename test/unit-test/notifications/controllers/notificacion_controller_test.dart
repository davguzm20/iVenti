import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/dtos/requests/CrearNotificacionRequest.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';

import '../../../mocks_mocks.dart';

final mockNotificacionService = MockNotificacionService();

NotificacionController buildController() => NotificacionController(mockNotificacionService);

void main() {
  setUp(() {
    reset(mockNotificacionService);
  });

  test('crearNotificacion delega a NotificacionService', () async {
    final notificacion = NotificacionEntity(
      idNotificacion: 1, idUsuario: 1, tipo: TipoNotificacion.STOCK_BAJO,
      titulo: 'Test', contenido: 'Test', creadoEn: DateTime.now(),
    );
    when(mockNotificacionService.crearNotificacion(any)).thenAnswer((_) async => notificacion);

    final request = CrearNotificacionRequest(
      idUsuario: 1, idProducto: 1, tipo: TipoNotificacion.STOCK_BAJO,
      titulo: 'Test', contenido: 'Test',
    );
    final result = await buildController().crearNotificacion(request);

    expect(result, notificacion);
    verify(mockNotificacionService.crearNotificacion(request)).called(1);
  });

  test('obtenerNotificaciones delega a NotificacionService', () async {
    when(mockNotificacionService.obtenerNotificaciones(1)).thenAnswer((_) async => []);

    final result = await buildController().obtenerNotificaciones(1);

    expect(result, []);
    verify(mockNotificacionService.obtenerNotificaciones(1)).called(1);
  });

  test('obtenerNoLeidas delega a NotificacionService', () async {
    when(mockNotificacionService.obtenerNoLeidas(1)).thenAnswer((_) async => []);

    final result = await buildController().obtenerNoLeidas(1);

    expect(result, []);
    verify(mockNotificacionService.obtenerNoLeidas(1)).called(1);
  });

  test('contarNoLeidas delega a NotificacionService', () async {
    when(mockNotificacionService.contarNoLeidas(1)).thenAnswer((_) async => 3);

    final result = await buildController().contarNoLeidas(1);

    expect(result, 3);
    verify(mockNotificacionService.contarNoLeidas(1)).called(1);
  });

  test('marcarComoLeida delega a NotificacionService', () async {
    when(mockNotificacionService.marcarComoLeida(1)).thenAnswer((_) async {});

    await buildController().marcarComoLeida(1);

    verify(mockNotificacionService.marcarComoLeida(1)).called(1);
  });

  test('marcarTodasComoLeidas delega a NotificacionService', () async {
    when(mockNotificacionService.marcarTodasComoLeidas(1)).thenAnswer((_) async {});

    await buildController().marcarTodasComoLeidas(1);

    verify(mockNotificacionService.marcarTodasComoLeidas(1)).called(1);
  });

  test('eliminarNotificacion delega a NotificacionService', () async {
    when(mockNotificacionService.eliminarNotificacion(1)).thenAnswer((_) async {});

    await buildController().eliminarNotificacion(1);

    verify(mockNotificacionService.eliminarNotificacion(1)).called(1);
  });

  test('limpiarHistorial delega a NotificacionService', () async {
    when(mockNotificacionService.limpiarHistorial(1)).thenAnswer((_) async {});

    await buildController().limpiarHistorial(1);

    verify(mockNotificacionService.limpiarHistorial(1)).called(1);
  });

  test('generarAlertasStock delega a NotificacionService', () async {
    when(mockNotificacionService.generarAlertasStock(1)).thenAnswer((_) async {});

    await buildController().generarAlertasStock(1);

    verify(mockNotificacionService.generarAlertasStock(1)).called(1);
  });

  test('generarAlertasVencimiento delega a NotificacionService', () async {
    when(mockNotificacionService.generarAlertasVencimiento(1)).thenAnswer((_) async {});

    await buildController().generarAlertasVencimiento(1);

    verify(mockNotificacionService.generarAlertasVencimiento(1)).called(1);
  });
}
