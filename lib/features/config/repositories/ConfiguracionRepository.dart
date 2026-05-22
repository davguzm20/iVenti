import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/config/entities/ConfiguracionEntity.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';
import 'package:iventi/features/config/mappers/ConfiguracionMapper.dart';
import 'package:iventi/features/config/repositories/IConfiguracionRepository.dart';

class ConfiguracionRepository implements IConfiguracionRepository {
  final PostgresDatasource _datasource;

  ConfiguracionRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  Future<ConfiguracionEntity?> obtenerConfiguracion(int idUsuario, String clave) async {
    final conexion = await _conexion;

    try {
      final configuracionesEncontradas = await conexion.execute(
        Sql.named('SELECT * FROM configuraciones WHERE id_usuario = @id_usuario AND clave = @clave'),
        parameters: {'id_usuario': idUsuario, 'clave': clave},
      );

      if (configuracionesEncontradas.isEmpty) return null;

      return ConfiguracionMapper.fromMap(configuracionesEncontradas.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al obtener configuracion: $e');
    }
  }

  Future<List<ConfiguracionEntity>> obtenerTodasConfiguraciones(int idUsuario) async {
    final conexion = await _conexion;

    try {
      final configuracionesEncontradas = await conexion.execute(
        Sql.named('SELECT * FROM configuraciones WHERE id_usuario = @id_usuario'),
        parameters: {'id_usuario': idUsuario},
      );

      return configuracionesEncontradas
          .map((fila) => ConfiguracionMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener configuraciones: $e');
    }
  }

  Future<ConfiguracionEntity> crearOActualizarConfiguracion(CrearConfiguracionRequest request) async {
    final conexion = await _conexion;

    try {
      final configuracionGuardada = await conexion.execute(
        Sql.named('''INSERT INTO configuraciones (id_usuario, clave, valor, creado_en, actualizado_en) VALUES (@id_usuario, @clave, @valor, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) ON CONFLICT (id_usuario, clave) DO UPDATE SET valor = @valor, actualizado_en = CURRENT_TIMESTAMP RETURNING *'''),
        parameters: {
          'id_usuario': request.idUsuario,
          'clave': request.clave.trim(),
          'valor': request.valor.trim(),
        },
      );

      return ConfiguracionMapper.fromMap(configuracionGuardada.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al crear/actualizar configuracion: $e');
    }
  }

  Future<void> eliminarConfiguracion(int idConfiguracion) async {
    final conexion = await _conexion;

    try {
      final configuracionEliminada = await conexion.execute(
        Sql.named('DELETE FROM configuraciones WHERE id_configuracion = @id'),
        parameters: {'id': idConfiguracion},
      );

      if (configuracionEliminada.affectedRows == 0) {
        throw NotFoundException('Configuracion no encontrada');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al eliminar configuracion: $e');
    }
  }
}
