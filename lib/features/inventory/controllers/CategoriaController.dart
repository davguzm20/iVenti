import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearCategoriaRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarCategoriaRequest.dart';
import 'package:iventi/features/inventory/services/CategoriaService.dart';

class CategoriaController {
  final CategoriaService _categoriaService;

  CategoriaController(this._categoriaService);

  Future<CategoriaEntity> crearCategoria(CrearCategoriaRequest request) {
    return _categoriaService.crearCategoria(request);
  }

  Future<CategoriaEntity> actualizarCategoria(ActualizarCategoriaRequest request) {
    return _categoriaService.actualizarCategoria(request);
  }

  Future<void> eliminarCategoria(int idCategoria) {
    return _categoriaService.eliminarCategoria(idCategoria);
  }

  Future<List<CategoriaEntity>> obtenerTodas() {
    return _categoriaService.obtenerTodas();
  }

  Future<List<CategoriaEntity>> obtenerDeProducto(int idProducto) {
    return _categoriaService.obtenerDeProducto(idProducto);
  }
}
