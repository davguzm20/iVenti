import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarProductoRequest.dart';

abstract class IProductoRepository {
  Future<ProductoEntity> crearProducto(CrearProductoRequest request);
  Future<ProductoEntity?> obtenerProductoPorId(int idProducto);
  Future<ProductoEntity?> obtenerProductoPorCodigo(String codigo);
  Future<List<ProductoEntity>> obtenerProductosPorNombre(String nombre);
  Future<List<ProductoEntity>> obtenerTodosLosProductos();
  Future<ProductoEntity> actualizarProducto(ActualizarProductoRequest request);
  Future<void> eliminarProducto(int idProducto);
  Future<void> actualizarStockActual(int idProducto);
  Future<List<ProductoEntity>> obtenerProductosPorFiltros({
    required int limite, required int offset,
    List<int>? idCategorias, bool? stockBajo,
  });
  Future<List<ProductoEntity>> obtenerProductosRecientes(int limite);
}
