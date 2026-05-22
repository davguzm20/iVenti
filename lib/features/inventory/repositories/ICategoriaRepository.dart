import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearCategoriaRequest.dart';

import 'package:iventi/features/inventory/dtos/requests/ActualizarCategoriaRequest.dart';

abstract class ICategoriaRepository {
  Future<CategoriaEntity> crearCategoria(CrearCategoriaRequest request);
  Future<CategoriaEntity> editarCategoria(ActualizarCategoriaRequest request);
  Future<void> eliminarCategoria(int idCategoria);
  Future<List<CategoriaEntity>> obtenerCategorias();
  Future<void> asignarRelacion(int idProducto, int idCategoria);
  Future<List<CategoriaEntity>> obtenerCategoriasDeProducto(int idProducto);
  Future<void> actualizarCategoriasProducto(int idProducto, List<int> idCategorias);
}
