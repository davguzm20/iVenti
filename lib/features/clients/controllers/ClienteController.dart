import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';
import 'package:iventi/features/clients/dtos/requests/ActualizarClienteRequest.dart';
import 'package:iventi/features/clients/services/ClienteService.dart';

class ClienteController {
  final ClienteService _clienteService;

  ClienteController(this._clienteService);

  Future<ClienteEntity> crearCliente(CrearClienteRequest request) {
    return _clienteService.crearCliente(request);
  }

  Future<ClienteEntity> actualizarCliente(ActualizarClienteRequest request) {
    return _clienteService.actualizarCliente(request);
  }

  Future<void> eliminarCliente(int idCliente) {
    return _clienteService.eliminarCliente(idCliente);
  }

  Future<ClienteEntity?> obtenerClientePorId(int idCliente) {
    return _clienteService.obtenerClientePorId(idCliente);
  }

  Future<List<ClienteEntity>> buscarPorNombre(String nombre) {
    return _clienteService.buscarPorNombre(nombre);
  }

  Future<List<ClienteEntity>> obtenerFiltrados({required int limite, required int offset, bool? esDeudor}) {
    return _clienteService.obtenerFiltrados(limite: limite, offset: offset, esDeudor: esDeudor);
  }
}
