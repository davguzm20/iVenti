import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';
import 'package:iventi/features/clients/dtos/requests/ActualizarClienteRequest.dart';
import 'package:iventi/features/clients/mappers/ClienteMapper.dart';

class ClienteRepository {
  final PostgresDatasource _datasource;

  ClienteRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  Future<ClienteEntity> crearCliente(CrearClienteRequest request) async {
    final conexion = await _conexion;

    try {
      final clienteCreado = await conexion.execute(
        Sql.named('INSERT INTO clientes (dni, nombres, apellidos, email, telefono, creado_en, actualizado_en) VALUES (@dni, @nombres, @apellidos, @email, @telefono, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING *'),
        parameters: {
          'dni': request.dni,
          'nombres': request.nombres.trim(),
          'apellidos': request.apellidos.trim(),
          'email': request.email,
          'telefono': request.telefono,
        },
      );

      return ClienteMapper.fromMap(clienteCreado.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al crear cliente: $e');
    }
  }

  Future<ClienteEntity?> obtenerClientePorId(int idCliente) async {
    final conexion = await _conexion;

    try {
      final clientesEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM clientes WHERE id_cliente = @id AND es_activo = TRUE'),
        parameters: {'id': idCliente},
      );

      if (clientesEncontrados.isEmpty) return null;

      return ClienteMapper.fromMap(clientesEncontrados.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al obtener cliente: $e');
    }
  }

  Future<List<ClienteEntity>> obtenerClientesPorNombre(String nombre) async {
    final conexion = await _conexion;

    try {
      final clientesEncontrados = await conexion.execute(
        Sql.named("SELECT * FROM clientes WHERE (nombres ILIKE '%' || @nombre || '%' OR apellidos ILIKE '%' || @nombre || '%') AND es_activo = TRUE"),
        parameters: {'nombre': nombre},
      );

      return clientesEncontrados
          .map((fila) => ClienteMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al buscar clientes: $e');
    }
  }

  Future<List<ClienteEntity>> obtenerClientesPorFiltros({required int limite, required int offset, bool? esDeudor}) async {
    final conexion = await _conexion;

    try {
      final parametros = <String, dynamic>{'limite': limite, 'offset': offset};
      String sql = 'SELECT * FROM clientes WHERE es_activo = TRUE';

      if (esDeudor == true) {
        sql += ' AND es_deudor = TRUE';
      } else if (esDeudor == false) {
        sql += ' AND es_deudor = FALSE';
      }

      sql += ' ORDER BY apellidos, nombres LIMIT @limite OFFSET @offset';

      final clientesEncontrados = await conexion.execute(Sql.named(sql), parameters: parametros);

      return clientesEncontrados
          .map((fila) => ClienteMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al filtrar clientes: $e');
    }
  }

  Future<ClienteEntity> actualizarCliente(ActualizarClienteRequest request) async {
    final conexion = await _conexion;

    try {
      final clienteActualizado = await conexion.execute(
        Sql.named('UPDATE clientes SET dni = @dni, nombres = @nombres, apellidos = @apellidos, email = @email, telefono = @telefono, actualizado_en = CURRENT_TIMESTAMP WHERE id_cliente = @id AND es_activo = TRUE RETURNING *'),
        parameters: {
          'id': request.idCliente,
          'dni': request.dni,
          'nombres': request.nombres.trim(),
          'apellidos': request.apellidos.trim(),
          'email': request.email,
          'telefono': request.telefono,
        },
      );

      if (clienteActualizado.isEmpty) {
        throw NotFoundException('Cliente no encontrado');
      }

      return ClienteMapper.fromMap(clienteActualizado.first.toColumnMap());
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al actualizar cliente: $e');
    }
  }

  Future<void> eliminarCliente(int idCliente) async {
    final conexion = await _conexion;

    try {
      final clienteEliminado = await conexion.execute(
        Sql.named('UPDATE clientes SET es_activo = FALSE, actualizado_en = CURRENT_TIMESTAMP WHERE id_cliente = @id AND es_activo = TRUE'),
        parameters: {'id': idCliente},
      );

      if (clienteEliminado.affectedRows == 0) {
        throw NotFoundException('Cliente no encontrado');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al eliminar cliente: $e');
    }
  }

  Future<void> actualizarEstadoDeudor(int idCliente) async {
    final conexion = await _conexion;

    try {
      final ventasPendientes = await conexion.execute(
        Sql.named("SELECT COUNT(*) AS pendientes FROM ventas WHERE id_cliente = @id AND estado = '${EstadoVenta.PENDIENTE.name}' AND (monto_total - monto_cancelado) > 0"),
        parameters: {'id': idCliente},
      );

      final totalPendientes = ventasPendientes.first.toColumnMap()['pendientes'] as int;

      await conexion.execute(
        Sql.named('UPDATE clientes SET es_deudor = @es_deudor, actualizado_en = CURRENT_TIMESTAMP WHERE id_cliente = @id'),
        parameters: {'es_deudor': totalPendientes > 0, 'id': idCliente},
      );
    } catch (e) {
      throw DatabaseException('Error al actualizar estado deudor: $e');
    }
  }
}
