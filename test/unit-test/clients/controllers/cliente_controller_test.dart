import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';
import 'package:iventi/features/clients/dtos/requests/ActualizarClienteRequest.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockClienteService mockService;
  late ClienteController controller;
  
  final cliente = ClienteEntity(
    idCliente: 1,
    nombres: 'Juan',
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockService = MockClienteService();
    controller = ClienteController(mockService);
  });

  test('crearCliente delega a ClienteService', () async {
    when(mockService.crearCliente(any)).thenAnswer((_) async => cliente);
    
    final request = CrearClienteRequest(nombres: 'Juan');
    final result = await controller.crearCliente(request);
    
    expect(result, cliente);
    verify(mockService.crearCliente(request)).called(1);
  });

  test('actualizarCliente delega a ClienteService', () async {
    when(mockService.actualizarCliente(any)).thenAnswer((_) async => cliente);
    
    final request = ActualizarClienteRequest(idCliente: 1, nombres: 'Juan');
    final result = await controller.actualizarCliente(request);
    
    expect(result, cliente);
    verify(mockService.actualizarCliente(request)).called(1);
  });

  test('eliminarCliente delega a ClienteService', () async {
    when(mockService.eliminarCliente(1)).thenAnswer((_) async {});
    
    await controller.eliminarCliente(1);
    
    verify(mockService.eliminarCliente(1)).called(1);
  });

  test('obtenerClientePorId delega a ClienteService', () async {
    when(mockService.obtenerClientePorId(1)).thenAnswer((_) async => cliente);
    
    final result = await controller.obtenerClientePorId(1);
    
    expect(result, cliente);
    verify(mockService.obtenerClientePorId(1)).called(1);
  });

  test('buscarPorNombre delega a ClienteService', () async {
    when(mockService.buscarPorNombre('Juan')).thenAnswer((_) async => [cliente]);
    
    final result = await controller.buscarPorNombre('Juan');
    
    expect(result, [cliente]);
    verify(mockService.buscarPorNombre('Juan')).called(1);
  });

  test('obtenerFiltrados delega a ClienteService', () async {
    when(mockService.obtenerFiltrados(limite: 10, offset: 0, esDeudor: anyNamed('esDeudor')))
        .thenAnswer((_) async => [cliente]);
    
    final result = await controller.obtenerFiltrados(limite: 10, offset: 0);
    
    expect(result, [cliente]);
    verify(mockService.obtenerFiltrados(limite: 10, offset: 0)).called(1);
  });
}
