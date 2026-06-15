import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';
import 'package:iventi/features/notifications/repositories/NotificacionRepository.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';
import 'package:iventi/features/notifications/dtos/requests/CrearNotificacionRequest.dart';
import 'package:iventi/features/inventory/repositories/ProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/LoteRepository.dart';
import 'package:iventi/features/config/repositories/ConfiguracionRepository.dart';

void main() {
  late PostgresDatasource datasource;
  late NotificacionService service;
  late int testUserId;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    datasource = PostgresDatasource();
    final conn = await datasource.connection;
    final userResult = await conn.execute(
      Sql.named(
        'INSERT INTO usuarios (rol, nombre, email, pin, creado_en, actualizado_en) '
        'VALUES (@rol, @nombre, @email, @pin, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) '
        'RETURNING id_usuario'),
      parameters: {
        'rol': 'ADMINISTRADOR',
        'nombre': 'Test User Notif',
        'email': 'notif.test.${DateTime.now().millisecondsSinceEpoch}@test.com',
        'pin': '123456',
      },
    );
    testUserId = userResult.first.toColumnMap()['id_usuario'] as int;
    await conn.execute("SET app.id_usuario = '$testUserId'");

    final notifRepo = NotificacionRepository(datasource);
    final productoRepo = ProductoRepository(datasource);
    final loteRepo = LoteRepository(datasource, productoRepo);
    final configRepo = ConfiguracionRepository(datasource);

    service = NotificacionService(notifRepo, productoRepo, loteRepo, configRepo);
  });

  tearDownAll(() async {
    if (testUserId > 0) {
      final conn = await datasource.connection;
      await conn.execute(
        Sql.named('DELETE FROM notificaciones WHERE id_usuario = @id'),
        parameters: {'id': testUserId});
      await conn.execute(
        Sql.named('DELETE FROM usuarios WHERE id_usuario = @id'),
        parameters: {'id': testUserId});
    }
  });

  group('NotificacionService con BD real', () {
    test('debe crear una notificacion correctamente [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final notif = await service.crearNotificacion(CrearNotificacionRequest(
        idUsuario: testUserId,
        tipo: TipoNotificacion.STOCK_BAJO,
        titulo: 'Stock Bajo Test',
        contenido: 'El producto X tiene stock bajo',
      ));

      expect(notif.idNotificacion, isNotNull);
      expect(notif.titulo, 'Stock Bajo Test');
      expect(notif.leida, isFalse);
    });

    test('debe crear y contar notificaciones no leidas [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      await service.crearNotificacion(CrearNotificacionRequest(
        idUsuario: testUserId,
        tipo: TipoNotificacion.STOCK_AGOTADO,
        titulo: 'Stock Agotado Test',
        contenido: 'Producto sin stock',
      ));
      await service.crearNotificacion(CrearNotificacionRequest(
        idUsuario: testUserId,
        tipo: TipoNotificacion.PROXIMO_VENCER,
        titulo: 'Proximo Vencer Test',
        contenido: 'Lote proximo a vencer',
      ));

      final noLeidas = await service.contarNoLeidas(testUserId);
      final todas = await service.obtenerNotificaciones(testUserId);

      expect(noLeidas, 2);
      expect(todas.length, 2);
    });

    test('debe marcar una notificacion como leida [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final creada = await service.crearNotificacion(CrearNotificacionRequest(
        idUsuario: testUserId,
        tipo: TipoNotificacion.STOCK_BAJO,
        titulo: 'Marcar Leida Test',
        contenido: 'Notificacion para marcar como leida',
      ));

      await service.marcarComoLeida(creada.idNotificacion!);

      final noLeidas = await service.contarNoLeidas(testUserId);
      final resultado = await service.obtenerNoLeidas(testUserId);

      expect(noLeidas, 0);
      expect(resultado, isEmpty);
    });

    test('debe marcar todas como leidas [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      await service.crearNotificacion(CrearNotificacionRequest(
        idUsuario: testUserId,
        tipo: TipoNotificacion.STOCK_BAJO,
        titulo: 'Bulk1',
        contenido: 'Test bulk 1',
      ));
      await service.crearNotificacion(CrearNotificacionRequest(
        idUsuario: testUserId,
        tipo: TipoNotificacion.STOCK_AGOTADO,
        titulo: 'Bulk2',
        contenido: 'Test bulk 2',
      ));

      await service.marcarTodasComoLeidas(testUserId);

      final noLeidas = await service.contarNoLeidas(testUserId);
      expect(noLeidas, 0);
    });

    test('debe eliminar una notificacion [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final creada = await service.crearNotificacion(CrearNotificacionRequest(
        idUsuario: testUserId,
        tipo: TipoNotificacion.VENCIDO,
        titulo: 'Eliminar Test',
        contenido: 'Notificacion a eliminar',
      ));

      await service.eliminarNotificacion(creada.idNotificacion!);

      final resultado = await service.obtenerNotificaciones(testUserId);
      expect(resultado, isEmpty);
    });

    test('debe limpiar historial [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      await service.crearNotificacion(CrearNotificacionRequest(
        idUsuario: testUserId,
        tipo: TipoNotificacion.STOCK_BAJO,
        titulo: 'Limpieza1',
        contenido: 'Test limpieza 1',
      ));
      await service.crearNotificacion(CrearNotificacionRequest(
        idUsuario: testUserId,
        tipo: TipoNotificacion.STOCK_AGOTADO,
        titulo: 'Limpieza2',
        contenido: 'Test limpieza 2',
      ));

      await service.limpiarHistorial(testUserId);

      final resultado = await service.obtenerNotificaciones(testUserId);
      expect(resultado, isEmpty);
    });
  });
}
