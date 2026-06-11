import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/features/clients/repositories/ClienteRepository.dart';
import 'package:iventi/features/clients/services/ClienteService.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';
import 'package:iventi/features/clients/dtos/requests/ActualizarClienteRequest.dart';

void main() {
  late PostgresDatasource datasource;
  late ClienteRepository clienteRepository;
  late ClienteService clienteService;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    datasource = PostgresDatasource();
    clienteRepository = ClienteRepository(datasource);
    clienteService = ClienteService(clienteRepository);
  });

  setUp(() async {
    final conn = await datasource.connection;
    await conn.execute('BEGIN');
  });

  tearDown(() async {
    final conn = await datasource.connection;
    await conn.execute('ROLLBACK');
  });

  tearDownAll(() async {
    await datasource.close();
  });

  int contador = 0;
  String dniUnico() =>
      'DNI${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}${contador++}';
  String emailUnico() =>
      'cliente_${DateTime.now().millisecondsSinceEpoch}_${contador++}@test.com';

  Future<ClienteEntity> crearCliente({String? dni}) async {
    final request = CrearClienteRequest(
      dni: dni ?? dniUnico(),
      nombres: 'Juan',
      email: emailUnico(),
      telefono: '999888777',
    );
    return await clienteService.crearCliente(request);
  }

  group('ClienteService.crearCliente con BD real', () {
    test(
        'debe crear un cliente correctamente cuando los datos son validos [en BD real]',
        () async {
      final email = emailUnico();
      final dni = dniUnico();
      final request = CrearClienteRequest(
        dni: dni,
        nombres: 'Maria',
        email: email,
        telefono: '999000111',
      );

      final cliente = await clienteService.crearCliente(request);

      expect(cliente.idCliente, isNotNull);
      expect(cliente.nombres, 'Maria');
      expect(cliente.email, email);
      expect(cliente.dni, dni);
      expect(cliente.telefono, '999000111');
      expect(cliente.esDeudor, false);
      expect(cliente.esActivo, true);
    });

    test(
        'debe crear un cliente sin dni, email y telefono cuando son opcionales [en BD real]',
        () async {
      final request = CrearClienteRequest(
        nombres: 'Pedro',
      );

      final cliente = await clienteService.crearCliente(request);

      expect(cliente.idCliente, isNotNull);
      expect(cliente.nombres, 'Pedro');
      expect(cliente.dni, isNull);
      expect(cliente.email, isNull);
      expect(cliente.telefono, isNull);
    });
  });

  group('ClienteService.obtenerClientePorId con BD real', () {
    test(
        'debe obtener un cliente por ID cuando existe [en BD real]',
        () async {
      final creado = await crearCliente();

      final cliente = await clienteService.obtenerClientePorId(creado.idCliente!);

      expect(cliente, isNotNull);
      expect(cliente!.idCliente, creado.idCliente);
      expect(cliente.nombres, 'Juan');
    });

    test(
        'debe devolver null cuando el ID no existe [en BD real]',
        () async {
      final cliente = await clienteService.obtenerClientePorId(-1);

      expect(cliente, isNull);
    });
  });

  group('ClienteService.buscarPorNombre con BD real', () {
    test(
        'debe encontrar clientes que coincidan con el nombre [en BD real]',
        () async {
      await crearCliente();
      await crearCliente();

      final resultados = await clienteService.buscarPorNombre('Juan');

      expect(resultados.length, greaterThanOrEqualTo(2));
      expect(resultados.every((c) =>
          c.nombres.contains('Juan')),
          isTrue);
    });

    test(
        'debe devolver lista vacia cuando no hay coincidencias [en BD real]',
        () async {
      final resultados = await clienteService.buscarPorNombre(
          'NombreInexistenteXYZ123');

      expect(resultados, isEmpty);
    });
  });

  group('ClienteService.obtenerFiltrados con BD real', () {
    test(
        'debe obtener clientes con paginacion [en BD real]',
        () async {
      await crearCliente();

      final resultados = await clienteService.obtenerFiltrados(
        limite: 10,
        offset: 0,
      );

      expect(resultados.length, greaterThanOrEqualTo(1));
    });

    test(
        'debe obtener solo clientes deudores cuando esDeudor es true [en BD real]',
        () async {
      final resultados = await clienteService.obtenerFiltrados(
        limite: 10,
        offset: 0,
        esDeudor: true,
      );

      expect(resultados.every((c) => c.esDeudor == true), isTrue);
    });
  });

  group('ClienteService.actualizarCliente con BD real', () {
    test(
        'debe actualizar un cliente correctamente [en BD real]',
        () async {
      final creado = await crearCliente();
      final nuevoDni = dniUnico();

      final actualizado = await clienteService.actualizarCliente(
        ActualizarClienteRequest(
          idCliente: creado.idCliente!,
          dni: nuevoDni,
          nombres: 'Juan Carlos',
          email: creado.email,
          telefono: '111222333',
        ),
      );

      expect(actualizado.nombres, 'Juan Carlos');
      expect(actualizado.dni, nuevoDni);
      expect(actualizado.telefono, '111222333');
    });

    test(
        'debe lanzar BusinessException cuando el cliente no existe [en BD real]',
        () async {
      expect(
        () => clienteService.actualizarCliente(
          ActualizarClienteRequest(
            idCliente: -1,
            nombres: 'Sin',
          ),
        ),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ClienteService.eliminarCliente con BD real', () {
    test(
        'debe eliminar (desactivar) un cliente correctamente [en BD real]',
        () async {
      final creado = await crearCliente();

      await clienteService.eliminarCliente(creado.idCliente!);

      final cliente = await clienteService.obtenerClientePorId(creado.idCliente!);
      expect(cliente, isNull);
    });

    test(
        'debe lanzar BusinessException cuando el cliente no existe [en BD real]',
        () async {
      expect(
        () => clienteService.eliminarCliente(-1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ClienteService.actualizarEstadoDeudor con BD real', () {
    test(
        'debe ejecutarse sin errores para un cliente existente [en BD real]',
        () async {
      final creado = await crearCliente();

      await clienteService.actualizarEstadoDeudor(creado.idCliente!);
    });
  });
}
