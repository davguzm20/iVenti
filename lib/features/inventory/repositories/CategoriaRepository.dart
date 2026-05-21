import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearCategoriaRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarCategoriaRequest.dart';
import 'package:iventi/features/inventory/mappers/CategoriaMapper.dart';

class CategoriaRepository {
  final PostgresDatasource _datasource;

  CategoriaRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  Future<CategoriaEntity> crearCategoria(CrearCategoriaRequest request) async {
    final conexion = await _conexion;

    try {
      final nuevaCategoria = await conexion.execute(
        Sql.named('INSERT INTO categorias (nombre, creado_en, actualizado_en) VALUES (@nombre, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING *'),
        parameters: {'nombre': request.nombre.trim()},
      );

      return CategoriaMapper.fromMap(nuevaCategoria.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al crear categoria: $e');
    }
  }

  Future<CategoriaEntity> editarCategoria(ActualizarCategoriaRequest request) async {
    final conexion = await _conexion;

    try {
      final categoriaActualizada = await conexion.execute(
        Sql.named('''
          UPDATE categorias SET nombre = @nombre, actualizado_en = CURRENT_TIMESTAMP
          WHERE id_categoria = @id AND es_activo = TRUE RETURNING *
        '''),
        parameters: {'nombre': request.nombre.trim(), 'id': request.idCategoria},
      );

      if (categoriaActualizada.isEmpty) {
        throw NotFoundException('Categoria no encontrada');
      }

      return CategoriaMapper.fromMap(categoriaActualizada.first.toColumnMap());
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al editar categoria: $e');
    }
  }

  Future<void> eliminarCategoria(int idCategoria) async {
    final conexion = await _conexion;

    try {
      final resultado = await conexion.execute(
        Sql.named('UPDATE categorias SET es_activo = FALSE, actualizado_en = CURRENT_TIMESTAMP WHERE id_categoria = @id AND es_activo = TRUE'),
        parameters: {'id': idCategoria},
      );

      if (resultado.affectedRows == 0) {
        throw NotFoundException('Categoria no encontrada');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al eliminar categoria: $e');
    }
  }

  Future<List<CategoriaEntity>> obtenerCategorias() async {
    final conexion = await _conexion;

    try {
      final categoriasEncontradas = await conexion.execute('SELECT * FROM categorias WHERE es_activo = TRUE ORDER BY nombre');

      return categoriasEncontradas
          .map((fila) => CategoriaMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener categorias: $e');
    }
  }

  Future<void> asignarRelacion(int idProducto, int idCategoria) async {
    final conexion = await _conexion;

    try {
      await conexion.execute(
        Sql.named('INSERT INTO categorias_productos (id_producto, id_categoria) VALUES (@id_producto, @id_categoria) ON CONFLICT DO NOTHING'),
        parameters: {'id_producto': idProducto, 'id_categoria': idCategoria},
      );
    } catch (e) {
      throw DatabaseException('Error al asignar relacion: $e');
    }
  }

  Future<List<CategoriaEntity>> obtenerCategoriasDeProducto(int idProducto) async {
    final conexion = await _conexion;

    try {
      final categoriasEncontradas = await conexion.execute(
        Sql.named('''
          SELECT c.* FROM categorias c
          INNER JOIN categorias_productos cp ON c.id_categoria = cp.id_categoria
          WHERE cp.id_producto = @id AND c.es_activo = TRUE
        '''),
        parameters: {'id': idProducto},
      );

      return categoriasEncontradas
          .map((fila) => CategoriaMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener categorias del producto: $e');
    }
  }

  Future<void> actualizarCategoriasProducto(int idProducto, List<int> idCategorias) async {
    final conexion = await _conexion;

    try {
      await conexion.execute(
        Sql.named('DELETE FROM categorias_productos WHERE id_producto = @id'),
        parameters: {'id': idProducto},
      );

      for (final idCategoria in idCategorias) {
        await asignarRelacion(idProducto, idCategoria);
      }
    } catch (e) {
      throw DatabaseException('Error al actualizar categorias del producto: $e');
    }
  }
}
