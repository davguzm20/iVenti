import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';
import 'package:iventi/features/clients/dtos/requests/ActualizarClienteRequest.dart';

abstract class IClienteRepository {
  Future<ClienteEntity> crearCliente(CrearClienteRequest request);
  Future<ClienteEntity?> obtenerClientePorId(int idCliente);
  Future<List<ClienteEntity>> obtenerClientesPorNombre(String nombre);
  Future<List<ClienteEntity>> obtenerClientesPorFiltros({required int limite, required int offset, bool? esDeudor});
  Future<ClienteEntity> actualizarCliente(ActualizarClienteRequest request);
  Future<void> eliminarCliente(int idCliente);
  Future<void> actualizarEstadoDeudor(int idCliente);
}
