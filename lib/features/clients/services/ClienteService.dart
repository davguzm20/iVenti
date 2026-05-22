import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';
import 'package:iventi/features/clients/dtos/requests/ActualizarClienteRequest.dart';
import 'package:iventi/features/clients/repositories/IClienteRepository.dart';

class ClienteService {
  final IClienteRepository _clienteRepository;

  ClienteService(this._clienteRepository);

  Future<ClienteEntity> crearCliente(CrearClienteRequest request) async {
    try {
      return await _clienteRepository.crearCliente(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al crear cliente: ${e.mensaje}');
    }
  }

  Future<ClienteEntity> actualizarCliente(ActualizarClienteRequest request) async {
    final clienteExistente = await _clienteRepository.obtenerClientePorId(request.idCliente);

    if (clienteExistente == null) {
      throw BusinessException('Cliente no encontrado');
    }

    try {
      return await _clienteRepository.actualizarCliente(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al actualizar cliente: ${e.mensaje}');
    }
  }

  Future<void> eliminarCliente(int idCliente) async {
    final clienteExistente = await _clienteRepository.obtenerClientePorId(idCliente);

    if (clienteExistente == null) {
      throw BusinessException('Cliente no encontrado');
    }

    try {
      await _clienteRepository.eliminarCliente(idCliente);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al eliminar cliente: ${e.mensaje}');
    }
  }

  Future<ClienteEntity?> obtenerClientePorId(int idCliente) async {
    try {
      return await _clienteRepository.obtenerClientePorId(idCliente);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener cliente: ${e.mensaje}');
    }
  }

  Future<List<ClienteEntity>> buscarPorNombre(String nombre) async {
    try {
      return await _clienteRepository.obtenerClientesPorNombre(nombre);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al buscar clientes: ${e.mensaje}');
    }
  }

  Future<List<ClienteEntity>> obtenerFiltrados({required int limite, required int offset, bool? esDeudor}) async {
    try {
      return await _clienteRepository.obtenerClientesPorFiltros(
        limite: limite,
        offset: offset,
        esDeudor: esDeudor,
      );

    } on DatabaseException catch (e) {
      throw BusinessException('Error al filtrar clientes: ${e.mensaje}');
    }
  }

  Future<void> actualizarEstadoDeudor(int idCliente) async {
    try {
      await _clienteRepository.actualizarEstadoDeudor(idCliente);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al actualizar estado deudor: ${e.mensaje}');
    }
  }
}
