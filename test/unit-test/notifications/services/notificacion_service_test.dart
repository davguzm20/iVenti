import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';
import 'package:iventi/features/notifications/dtos/requests/CrearNotificacionRequest.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/config/entities/ConfiguracionEntity.dart';

import '../../../mocks_mocks.dart';

final mockNotificacionRepository = MockINotificacionRepository();
final mockProductoRepository = MockIProductoRepository();
final mockLoteRepository = MockILoteRepository();
final mockConfiguracionRepository = MockIConfiguracionRepository();

NotificacionService buildService() => NotificacionService(
  mockNotificacionRepository,
  mockProductoRepository,
  mockLoteRepository,
  mockConfiguracionRepository,
);

void main() {
  setUp(() {
    reset(mockNotificacionRepository);
    reset(mockProductoRepository);
    reset(mockLoteRepository);
    reset(mockConfiguracionRepository);
  });

  group('NotificacionService.crearNotificacion', () {
    test('debe crear notificacion correctamente', () async {
      final notificacion = NotificacionEntity(
        idNotificacion: 1, idUsuario: 1, tipo: TipoNotificacion.STOCK_BAJO,
        titulo: 'Test', contenido: 'Test', creadoEn: DateTime.now(),
      );
      final request = CrearNotificacionRequest(
        idUsuario: 1, tipo: TipoNotificacion.STOCK_BAJO,
        titulo: 'Test', contenido: 'Test',
      );

      when(mockNotificacionRepository.crearNotificacion(any))
          .thenAnswer((_) async => notificacion);

      final result = await buildService().crearNotificacion(request);

      expect(result, notificacion);
      verify(mockNotificacionRepository.crearNotificacion(request)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = CrearNotificacionRequest(
        idUsuario: 1, tipo: TipoNotificacion.STOCK_BAJO,
        titulo: 'Test', contenido: 'Test',
      );

      when(mockNotificacionRepository.crearNotificacion(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().crearNotificacion(request),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('NotificacionService.obtenerNotificaciones', () {
    test('debe retornar lista de notificaciones', () async {
      final notificaciones = [
        NotificacionEntity(idNotificacion: 1, idUsuario: 1, tipo: TipoNotificacion.STOCK_BAJO, titulo: 'Test', contenido: 'Test', creadoEn: DateTime.now()),
      ];
      when(mockNotificacionRepository.obtenerNotificaciones(1)).thenAnswer((_) async => notificaciones);

      final result = await buildService().obtenerNotificaciones(1);

      expect(result, notificaciones);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockNotificacionRepository.obtenerNotificaciones(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerNotificaciones(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al obtener notificaciones'))),
      );
    });
  });

  group('NotificacionService.obtenerNoLeidas', () {
    test('debe retornar lista de no leidas', () async {
      when(mockNotificacionRepository.obtenerNotificacionesNoLeidas(1)).thenAnswer((_) async => []);

      final result = await buildService().obtenerNoLeidas(1);

      expect(result, []);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockNotificacionRepository.obtenerNotificacionesNoLeidas(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().obtenerNoLeidas(1),
        throwsA(isA<BusinessException>()),
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

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockNotificacionRepository.contarNotificacionesNoLeidas(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().contarNoLeidas(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('NotificacionService.marcarComoLeida', () {
    test('debe marcar notificacion como leida', () async {
      when(mockNotificacionRepository.marcarComoLeida(1)).thenAnswer((_) async {});

      await buildService().marcarComoLeida(1);

      verify(mockNotificacionRepository.marcarComoLeida(1)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockNotificacionRepository.marcarComoLeida(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().marcarComoLeida(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('NotificacionService.marcarTodasComoLeidas', () {
    test('debe marcar todas como leidas', () async {
      when(mockNotificacionRepository.marcarTodasComoLeidas(1)).thenAnswer((_) async {});

      await buildService().marcarTodasComoLeidas(1);

      verify(mockNotificacionRepository.marcarTodasComoLeidas(1)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockNotificacionRepository.marcarTodasComoLeidas(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().marcarTodasComoLeidas(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('NotificacionService.eliminarNotificacion', () {
    test('debe eliminar notificacion correctamente', () async {
      when(mockNotificacionRepository.eliminarNotificacion(any))
          .thenAnswer((_) async => Future.value());

      await buildService().eliminarNotificacion(1);

      verify(mockNotificacionRepository.eliminarNotificacion(1)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockNotificacionRepository.eliminarNotificacion(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().eliminarNotificacion(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('NotificacionService.limpiarHistorial', () {
    test('debe limpiar historial', () async {
      when(mockNotificacionRepository.limpiarHistorial(1)).thenAnswer((_) async {});

      await buildService().limpiarHistorial(1);

      verify(mockNotificacionRepository.limpiarHistorial(1)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockNotificacionRepository.limpiarHistorial(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().limpiarHistorial(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('NotificacionService.generarAlertasStock', () {
    test('debe generar alertas de stock bajo y agotado', () async {
      final productos = [
        ProductoEntity(idProducto: 1, idUnidad: 1, nombre: 'Sin Stock', precio: 100, stockActual: 0, stockMinimo: 5, esActivo: true, creadoEn: DateTime.now()),
        ProductoEntity(idProducto: 2, idUnidad: 1, nombre: 'Stock Bajo', precio: 100, stockActual: 3, stockMinimo: 5, esActivo: true, creadoEn: DateTime.now()),
        ProductoEntity(idProducto: 3, idUnidad: 1, nombre: 'Stock OK', precio: 100, stockActual: 10, stockMinimo: 5, esActivo: true, creadoEn: DateTime.now()),
      ];

      when(mockProductoRepository.obtenerTodosLosProductos()).thenAnswer((_) async => productos);
      when(mockNotificacionRepository.crearNotificacion(any)).thenAnswer((_) async =>
        NotificacionEntity(idUsuario: 1, tipo: TipoNotificacion.STOCK_BAJO, titulo: '', contenido: '', creadoEn: DateTime.now()));

      await buildService().generarAlertasStock(1);

      verify(mockNotificacionRepository.crearNotificacion(any)).called(2);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockProductoRepository.obtenerTodosLosProductos())
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().generarAlertasStock(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar alertas de stock'))),
      );
    });
  });

  group('NotificacionService.generarAlertasVencimiento', () {
    test('debe generar alertas de vencimiento', () async {
      when(mockConfiguracionRepository.obtenerConfiguracion(1, 'dias_vencimiento'))
          .thenAnswer((_) async => ConfiguracionEntity(idConfiguracion: 1, idUsuario: 1, clave: 'dias_vencimiento', valor: '30', creadoEn: DateTime.now()));

      final lotes = [
        LoteEntity(idLote: 1, idProducto: 1, fechaCompra: DateTime.now(), fechaVencimiento: DateTime.now().add(Duration(days: 15)), cantidadActual: 10, cantidadComprada: 10, cantidadPerdida: 0, precioCompra: 50, creadoEn: DateTime.now()),
      ];
      when(mockLoteRepository.obtenerLotesProximosAVencer(30)).thenAnswer((_) async => lotes);
      when(mockNotificacionRepository.crearNotificacion(any)).thenAnswer((_) async =>
        NotificacionEntity(idUsuario: 1, tipo: TipoNotificacion.PROXIMO_VENCER, titulo: '', contenido: '', creadoEn: DateTime.now()));

      await buildService().generarAlertasVencimiento(1);

      verify(mockNotificacionRepository.crearNotificacion(any)).called(1);
    });

    test('debe usar default 8 dias cuando no hay configuracion', () async {
      when(mockConfiguracionRepository.obtenerConfiguracion(1, 'dias_vencimiento'))
          .thenAnswer((_) async => null);

      when(mockLoteRepository.obtenerLotesProximosAVencer(8)).thenAnswer((_) async => []);

      await buildService().generarAlertasVencimiento(1);

      verify(mockLoteRepository.obtenerLotesProximosAVencer(8)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockConfiguracionRepository.obtenerConfiguracion(any, any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().generarAlertasVencimiento(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al generar alertas de vencimiento'))),
      );
    });
  });
}
