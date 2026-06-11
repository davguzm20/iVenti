import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarProductoRequest.dart';
import 'package:iventi/features/inventory/repositories/IProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/ICategoriaRepository.dart';

class ProductoService {
  final IProductoRepository _productoRepository;
  final ICategoriaRepository _categoriaRepository;

  ProductoService(this._productoRepository, this._categoriaRepository);

  Future<ProductoEntity> crearProducto(CrearProductoRequest request, {List<int>? idCategorias}) async {
    if (request.codigo != null && request.codigo!.isNotEmpty) {
      final productoExistente = await _productoRepository.obtenerProductoPorCodigo(request.codigo!);

      if (productoExistente != null) {
        throw BusinessException('El codigo ${request.codigo} ya esta en uso');
      }
    }

    try {
      final producto = await _productoRepository.crearProducto(request);

      if (idCategorias != null && idCategorias.isNotEmpty) {
        await _categoriaRepository.actualizarCategoriasProducto(producto.idProducto!, idCategorias);
      }

      return producto;

    } on DatabaseException catch (e) {
      throw BusinessException('Error al crear producto: ${e.mensaje}');
    }
  }

  Future<ProductoEntity> actualizarProducto(ActualizarProductoRequest request, {List<int>? idCategorias}) async {
    final productoExistente = await _productoRepository.obtenerProductoPorId(request.idProducto);

    if (productoExistente == null) {
      throw BusinessException('Producto no encontrado');
    }

    try {
      final producto = await _productoRepository.actualizarProducto(request);

      if (idCategorias != null) {
        await _categoriaRepository.actualizarCategoriasProducto(producto.idProducto!, idCategorias);
      }

      return producto;

    } on DatabaseException catch (e) {
      throw BusinessException('Error al actualizar producto: ${e.mensaje}');
    }
  }

  Future<void> eliminarProducto(int idProducto) async {
    final productoExistente = await _productoRepository.obtenerProductoPorId(idProducto);

    if (productoExistente == null) {
      throw BusinessException('Producto no encontrado');
    }

    try {
      await _productoRepository.eliminarProducto(idProducto);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al eliminar producto: ${e.mensaje}');
    }
  }

  Future<ProductoEntity?> obtenerProductoPorId(int idProducto) async {
    try {
      return await _productoRepository.obtenerProductoPorId(idProducto);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener producto: ${e.mensaje}');
    }
  }

  Future<ProductoEntity?> obtenerProductoPorCodigo(String codigo) async {
    try {
      return await _productoRepository.obtenerProductoPorCodigo(codigo);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener producto por codigo: ${e.mensaje}');
    }
  }

  Future<List<ProductoEntity>> buscarPorNombre(String nombre) async {
    try {
      return await _productoRepository.obtenerProductosPorNombre(nombre);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al buscar productos: ${e.mensaje}');
    }
  }

  Future<List<ProductoEntity>> obtenerTodos() async {
    try {
      return await _productoRepository.obtenerTodosLosProductos();

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener productos: ${e.mensaje}');
    }
  }

  Future<List<ProductoEntity>> obtenerFiltrados({
    required int limite,
    required int offset,
    List<int>? idCategorias,
    bool? stockBajo,
  }) async {
    try {
      return await _productoRepository.obtenerProductosPorFiltros(
        limite: limite,
        offset: offset,
        idCategorias: idCategorias,
        stockBajo: stockBajo,
      );

    } on DatabaseException catch (e) {
      throw BusinessException('Error al filtrar productos: ${e.mensaje}');
    }
  }

  Future<List<ProductoEntity>> obtenerProductosRecientes(int limite) async {
    try {
      return await _productoRepository.obtenerProductosRecientes(limite);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener productos recientes: ${e.mensaje}');
    }
  }
}
