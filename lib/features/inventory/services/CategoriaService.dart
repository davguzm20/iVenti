import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearCategoriaRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarCategoriaRequest.dart';
import 'package:iventi/features/inventory/repositories/ICategoriaRepository.dart';

class CategoriaService {
  final ICategoriaRepository _categoriaRepository;

  CategoriaService(this._categoriaRepository);

  Future<CategoriaEntity> crearCategoria(CrearCategoriaRequest request) async {
    try {
      return await _categoriaRepository.crearCategoria(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al crear categoria: ${e.mensaje}');
    }
  }

  Future<CategoriaEntity> actualizarCategoria(ActualizarCategoriaRequest request) async {
    try {
      return await _categoriaRepository.editarCategoria(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al actualizar categoria: ${e.mensaje}');
    }
  }

  Future<void> eliminarCategoria(int idCategoria) async {
    try {
      await _categoriaRepository.eliminarCategoria(idCategoria);

    } on NotFoundException {
      throw BusinessException('Categoria no encontrada');

    } on DatabaseException catch (e) {
      throw BusinessException('Error al eliminar categoria: ${e.mensaje}');
    }
  }

  Future<List<CategoriaEntity>> obtenerTodas() async {
    try {
      return await _categoriaRepository.obtenerCategorias();

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener categorias: ${e.mensaje}');
    }
  }

  Future<List<CategoriaEntity>> obtenerDeProducto(int idProducto) async {
    try {
      return await _categoriaRepository.obtenerCategoriasDeProducto(idProducto);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener categorias del producto: ${e.mensaje}');
    }
  }
}
