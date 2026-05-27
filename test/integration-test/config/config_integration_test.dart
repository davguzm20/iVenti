import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/config/services/ConfiguracionService.dart';
import 'package:iventi/features/config/repositories/ConfiguracionRepository.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';

void main() {
  late PostgresDatasource datasource;
  late ConfiguracionRepository repository;
  late ConfiguracionService service;
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
        'nombre': 'Test User Config',
        'email': 'config.test.${DateTime.now().millisecondsSinceEpoch}@test.com',
        'pin': '123456',
      },
    );
    testUserId = userResult.first.toColumnMap()['id_usuario'] as int;
    repository = ConfiguracionRepository(datasource);
    service = ConfiguracionService(repository);
  });

  tearDownAll(() async {
    if (testUserId > 0) {
      final conn = await datasource.connection;
      await conn.execute(
        Sql.named('DELETE FROM configuraciones WHERE id_usuario = @id'),
        parameters: {'id': testUserId});
      await conn.execute(
        Sql.named('DELETE FROM usuarios WHERE id_usuario = @id'),
        parameters: {'id': testUserId});
    }
  });

  test('guardarConfiguracion debe crear una configuracion correctamente [en BD real]', () async {
    final conn = await datasource.connection;
    await conn.execute('BEGIN');
    addTearDown(() => conn.execute('ROLLBACK'));

    final config = await service.guardarConfiguracion(CrearConfiguracionRequest(
      idUsuario: testUserId,
      clave: 'test_clave_${DateTime.now().millisecondsSinceEpoch}',
      valor: 'test_valor',
    ));

    expect(config.idConfiguracion, isNotNull);
    expect(config.clave, contains('test_clave'));
    expect(config.valor, 'test_valor');
  });

  test('guardarConfiguracion debe actualizar una configuracion existente [en BD real]', () async {
    final conn = await datasource.connection;
    await conn.execute('BEGIN');
    addTearDown(() => conn.execute('ROLLBACK'));

    final clave = 'upsert_clave_${DateTime.now().millisecondsSinceEpoch}';
    final creada = await service.guardarConfiguracion(CrearConfiguracionRequest(
      idUsuario: testUserId,
      clave: clave,
      valor: 'valor_inicial',
    ));
    final actualizada = await service.guardarConfiguracion(CrearConfiguracionRequest(
      idUsuario: testUserId,
      clave: clave,
      valor: 'valor_actualizado',
    ));

    expect(actualizada.idConfiguracion, creada.idConfiguracion);
    expect(actualizada.valor, 'valor_actualizado');
  });

  test('obtenerConfiguracion debe devolver null cuando la clave no existe [en BD real]', () async {
    final conn = await datasource.connection;
    await conn.execute('BEGIN');
    addTearDown(() => conn.execute('ROLLBACK'));

    final resultado = await service.obtenerConfiguracion(testUserId, 'clave_inexistente');

    expect(resultado, isNull);
  });

  test('eliminarConfiguracion debe lanzar BusinessException cuando no existe [en BD real]', () async {
    final conn = await datasource.connection;
    await conn.execute('BEGIN');
    addTearDown(() => conn.execute('ROLLBACK'));

    expect(
      () => service.eliminarConfiguracion(-1),
      throwsA(isA<NotFoundException>()),
    );
  });
}
