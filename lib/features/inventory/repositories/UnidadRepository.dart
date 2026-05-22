import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/mappers/UnidadMapper.dart';
import 'package:iventi/features/inventory/repositories/IUnidadRepository.dart';

class UnidadRepository implements IUnidadRepository {
  final PostgresDatasource _datasource;

  UnidadRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  Future<List<UnidadEntity>> obtenerUnidades() async {
    final conexion = await _conexion;

    try {
      final unidadesEncontradas = await conexion.execute('SELECT * FROM unidades WHERE es_activo = TRUE ORDER BY nombre');

      return unidadesEncontradas
          .map((fila) => UnidadMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener unidades: $e');
    }
  }

  Future<UnidadEntity?> obtenerUnidadPorId(int idUnidad) async {
    final conexion = await _conexion;

    try {
      final unidadEncontrada = await conexion.execute(
        Sql.named('SELECT * FROM unidades WHERE id_unidad = @id AND es_activo = TRUE'),
        parameters: {'id': idUnidad},
      );

      if (unidadEncontrada.isEmpty) return null;

      return UnidadMapper.fromMap(unidadEncontrada.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al obtener unidad: $e');
    }
  }
}
