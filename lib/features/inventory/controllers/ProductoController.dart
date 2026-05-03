import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarProductoRequest.dart';
import 'package:iventi/features/inventory/services/ProductoService.dart';

class ProductoController {
  final ProductoService _productoService;

  ProductoController(this._productoService);

  Future<ProductoEntity> crearProducto(CrearProductoRequest request, {List<int>? idCategorias}) {
    return _productoService.crearProducto(request, idCategorias: idCategorias);
  }

  Future<ProductoEntity> actualizarProducto(ActualizarProductoRequest request, {List<int>? idCategorias}) {
    return _productoService.actualizarProducto(request, idCategorias: idCategorias);
  }

  Future<void> eliminarProducto(int idProducto) {
    return _productoService.eliminarProducto(idProducto);
  }

  Future<ProductoEntity?> obtenerProductoPorId(int idProducto) {
    return _productoService.obtenerProductoPorId(idProducto);
  }

  Future<ProductoEntity?> obtenerProductoPorCodigo(String codigo) {
    return _productoService.obtenerProductoPorCodigo(codigo);
  }

  Future<List<ProductoEntity>> buscarPorNombre(String nombre) {
    return _productoService.buscarPorNombre(nombre);
  }

  Future<List<ProductoEntity>> obtenerTodos() {
    return _productoService.obtenerTodos();
  }

  Future<List<ProductoEntity>> obtenerFiltrados({
    required int limite,
    required int offset,
    List<int>? idCategorias,
    bool? stockBajo,
  }) {
    return _productoService.obtenerFiltrados(
      limite: limite,
      offset: offset,
      idCategorias: idCategorias,
      stockBajo: stockBajo,
    );
  }
}
