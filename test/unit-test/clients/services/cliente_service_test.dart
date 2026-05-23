import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';
import 'package:iventi/features/clients/dtos/requests/ActualizarClienteRequest.dart';
import 'package:iventi/features/clients/services/ClienteService.dart';
import 'package:iventi/features/clients/repositories/IClienteRepository.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockIClienteRepository mockRepo;
  late ClienteService service;

  final clienteValido = ClienteEntity(
    idCliente: 1,
    nombres: 'Juan',
    apellidos: 'Perez',
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockIClienteRepository();
    service = ClienteService(mockRepo);
  });

  group('ClienteService.crearCliente', () {
    test('debe crear cliente correctamente', () async {
      when(mockRepo.crearCliente(any)).thenAnswer((_) async => clienteValido);

      final request = CrearClienteRequest(nombres: 'Juan', apellidos: 'Perez');
      final result = await service.crearCliente(request);

      expect(result, clienteValido);
      verify(mockRepo.crearCliente(request)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.crearCliente(any)).thenThrow(DatabaseException('Error BD'));

      final request = CrearClienteRequest(nombres: 'Juan', apellidos: 'Perez');

      expect(
        () => service.crearCliente(request),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ClienteService.actualizarCliente', () {
    test('debe actualizar cliente cuando existe', () async {
      when(mockRepo.obtenerClientePorId(1)).thenAnswer((_) async => clienteValido);
      when(mockRepo.actualizarCliente(any)).thenAnswer((_) async => clienteValido);

      final request = ActualizarClienteRequest(idCliente: 1, nombres: 'Juan', apellidos: 'Perez');
      final result = await service.actualizarCliente(request);

      expect(result, clienteValido);
    });

    test('debe lanzar BusinessException cuando cliente no existe', () async {
      when(mockRepo.obtenerClientePorId(999)).thenAnswer((_) async => null);

      final request = ActualizarClienteRequest(idCliente: 999, nombres: 'Juan', apellidos: 'Perez');

      expect(
        () => service.actualizarCliente(request),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ClienteService.eliminarCliente', () {
    test('debe eliminar cliente cuando existe', () async {
      when(mockRepo.obtenerClientePorId(1)).thenAnswer((_) async => clienteValido);
      when(mockRepo.eliminarCliente(1)).thenAnswer((_) async => null);

      await service.eliminarCliente(1);

      verify(mockRepo.eliminarCliente(1)).called(1);
    });

    test('debe lanzar BusinessException cuando cliente no existe', () async {
      when(mockRepo.obtenerClientePorId(999)).thenAnswer((_) async => null);

      expect(
        () => service.eliminarCliente(999),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('ClienteService.obtenerClientePorId', () {
    test('debe retornar cliente cuando existe', () async {
      when(mockRepo.obtenerClientePorId(1)).thenAnswer((_) async => clienteValido);

      final result = await service.obtenerClientePorId(1);

      expect(result, clienteValido);
    });

    test('debe retornar null cuando no existe', () async {
      when(mockRepo.obtenerClientePorId(999)).thenAnswer((_) async => null);

      final result = await service.obtenerClientePorId(999);

      expect(result, isNull);
    });
  });

  group('ClienteService.buscarPorNombre', () {
    test('debe retornar lista de clientes', () async {
      when(mockRepo.obtenerClientesPorNombre('Juan'))
          .thenAnswer((_) async => [clienteValido]);

      final result = await service.buscarPorNombre('Juan');

      expect(result, [clienteValido]);
    });
  });

  group('ClienteService.obtenerFiltrados', () {
    test('debe retornar clientes filtrados', () async {
      when(mockRepo.obtenerClientesPorFiltros(
        limite: 10, offset: 0, esDeudor: anyNamed('esDeudor'),
      )).thenAnswer((_) async => [clienteValido]);

      final result = await service.obtenerFiltrados(limite: 10, offset: 0);

      expect(result, [clienteValido]);
    });
  });

  group('ClienteService.actualizarEstadoDeudor', () {
    test('debe actualizar estado deudor', () async {
      when(mockRepo.actualizarEstadoDeudor(1)).thenAnswer((_) async => null);

      await service.actualizarEstadoDeudor(1);

      verify(mockRepo.actualizarEstadoDeudor(1)).called(1);
    });
  });
}
