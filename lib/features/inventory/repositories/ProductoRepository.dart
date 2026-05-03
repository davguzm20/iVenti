import 'package:postgres/postgres.dart';
import 'package:iventi/shared/datasources/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarProductoRequest.dart';
import 'package:iventi/features/inventory/mappers/ProductoMapper.dart';

class ProductoRepository {
  final PostgresDatasource _datasource;

  ProductoRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  Future<ProductoEntity> crearProducto(CrearProductoRequest request) async {
    final conexion = await _conexion;

    try {
      final productoInsertado = await conexion.execute(
        Sql.named('''
          INSERT INTO productos (id_unidad, codigo, nombre, precio, stock_actual, stock_minimo, ruta_imagen, creado_en, actualizado_en)
          VALUES (@id_unidad, @codigo, @nombre, @precio, 0, @stock_minimo, @ruta_imagen, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
          RETURNING id_producto, creado_en
        '''),
        parameters: {
          'id_unidad': request.idUnidad,
          'codigo': request.codigo,
          'nombre': request.nombre.trim(),
          'precio': request.precio,
          'stock_minimo': request.stockMinimo,
          'ruta_imagen': request.rutaImagen,
        },
      );

      final nuevoId = productoInsertado.first.toColumnMap()['id_producto'] as int;
      final creadoEn = productoInsertado.first.toColumnMap()['creado_en'] as DateTime;

      return ProductoEntity(
        idProducto: nuevoId,
        idUnidad: request.idUnidad,
        codigo: request.codigo,
        nombre: request.nombre.trim(),
        precio: request.precio,
        stockActual: 0,
        stockMinimo: request.stockMinimo,
        rutaImagen: request.rutaImagen,
        esActivo: true,
        creadoEn: creadoEn,
      );
    } catch (e) {
      throw DatabaseException('Error al crear producto: $e');
    }
  }

  Future<ProductoEntity?> obtenerProductoPorID(int idProducto) async {
    final conexion = await _conexion;

    try {
      final productosEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM productos WHERE id_producto = @id AND es_activo = TRUE'),
        parameters: {'id': idProducto},
      );

      if (productosEncontrados.isEmpty) return null;

      return ProductoMapper.fromMap(productosEncontrados.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al obtener producto: $e');
    }
  }

  Future<ProductoEntity?> obtenerProductoPorCodigo(String codigo) async {
    final conexion = await _conexion;

    try {
      final productosEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM productos WHERE codigo = @codigo AND es_activo = TRUE'),
        parameters: {'codigo': codigo},
      );

      if (productosEncontrados.isEmpty) return null;

      return ProductoMapper.fromMap(productosEncontrados.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al obtener producto por codigo: $e');
    }
  }

  Future<List<ProductoEntity>> obtenerProductosPorNombre(String nombre) async {
    final conexion = await _conexion;

    try {
      final productosEncontrados = await conexion.execute(
        Sql.named("SELECT * FROM productos WHERE nombre ILIKE '%' || @nombre || '%' AND es_activo = TRUE"),
        parameters: {'nombre': nombre},
      );

      return productosEncontrados
          .map((fila) => ProductoMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al buscar productos: $e');
    }
  }

  Future<List<ProductoEntity>> obtenerTodosLosProductos() async {
    final conexion = await _conexion;

    try {
      const sql = 'SELECT * FROM productos WHERE es_activo = TRUE ORDER BY nombre';
      final productosEncontrados = await conexion.execute(sql);

      return productosEncontrados
          .map((fila) => ProductoMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener productos: $e');
    }
  }

  Future<ProductoEntity> actualizarProducto(ActualizarProductoRequest request) async {
    final conexion = await _conexion;

    try {
      final productoActualizado = await conexion.execute(
        Sql.named('''
          UPDATE productos
          SET id_unidad = @id_unidad, codigo = @codigo, nombre = @nombre,
              precio = @precio, stock_minimo = @stock_minimo,
              ruta_imagen = @ruta_imagen, actualizado_en = CURRENT_TIMESTAMP
          WHERE id_producto = @id AND es_activo = TRUE
          RETURNING *
        '''),
        parameters: {
          'id': request.idProducto,
          'id_unidad': request.idUnidad,
          'codigo': request.codigo,
          'nombre': request.nombre.trim(),
          'precio': request.precio,
          'stock_minimo': request.stockMinimo,
          'ruta_imagen': request.rutaImagen,
        },
      );

      if (productoActualizado.isEmpty) {
        throw NotFoundException('Producto no encontrado');
      }

      return ProductoMapper.fromMap(productoActualizado.first.toColumnMap());
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al actualizar producto: $e');
    }
  }

  Future<void> eliminarProducto(int idProducto) async {
    final conexion = await _conexion;

    try {
      final productoEliminado = await conexion.execute(
        Sql.named('''
          UPDATE productos
          SET es_activo = FALSE, actualizado_en = CURRENT_TIMESTAMP
          WHERE id_producto = @id AND es_activo = TRUE
        '''),
        parameters: {'id': idProducto},
      );

      if (productoEliminado.affectedRows == 0) {
        throw NotFoundException('Producto no encontrado');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al eliminar producto: $e');
    }
  }

  Future<void> actualizarStockActual(int idProducto) async {
    final conexion = await _conexion;

    try {
      final stockCalculado = await conexion.execute(
        Sql.named('''
          SELECT COALESCE(SUM(cantidad_actual), 0) AS stock_total
          FROM lotes
          WHERE id_producto = @id AND es_activo = TRUE
        '''),
        parameters: {'id': idProducto},
      );

      final stockTotal = stockCalculado.first.toColumnMap()['stock_total'] as int;

      await conexion.execute(
        Sql.named('''
          UPDATE productos
          SET stock_actual = @stock, actualizado_en = CURRENT_TIMESTAMP
          WHERE id_producto = @id
        '''),
        parameters: {'stock': stockTotal, 'id': idProducto},
      );
    } catch (e) {
      throw DatabaseException('Error al actualizar stock: $e');
    }
  }

  Future<List<ProductoEntity>> obtenerProductosPorFiltros({
    required int limite,
    required int offset,
    List<int>? idCategorias,
    bool? stockBajo,
  }) async {
    final conexion = await _conexion;

    try {
      final tieneFiltroCategorias = (idCategorias != null && idCategorias.isNotEmpty);
      final parametros = <String, dynamic>{'limite': limite, 'offset': offset};

      String sql = 'SELECT DISTINCT p.* FROM productos p';

      if (tieneFiltroCategorias) {
        sql += ' LEFT JOIN categorias_productos cp ON p.id_producto = cp.id_producto';
      }

      sql += ' WHERE p.es_activo = TRUE';

      if (tieneFiltroCategorias) {
        final marcadores = idCategorias.asMap().keys.map((i) => '@cat_$i').join(', ');
        sql += ' AND cp.id_categoria IN ($marcadores)';

        for (var i = 0; i < idCategorias.length; i++) {
          parametros['cat_$i'] = idCategorias[i];
        }
      }

      if (stockBajo == true) {
        sql += ' AND p.stock_actual < p.stock_minimo';
      } else if (stockBajo == false) {
        sql += ' AND p.stock_actual >= p.stock_minimo';
      }

      sql += ' ORDER BY p.nombre LIMIT @limite OFFSET @offset';

      final productosEncontrados = await conexion.execute(Sql.named(sql), parameters: parametros);

      return productosEncontrados
          .map((fila) => ProductoMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al filtrar productos: $e');
    }
  }
}
