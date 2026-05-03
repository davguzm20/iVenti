import 'package:iventi/shared/exceptions/ValidationException.dart';

class CrearProductoRequest {
  final int idUnidad;
  final String? codigo;
  final String nombre;
  final double precio;
  final int stockMinimo;
  final String? rutaImagen;
  final List<int> idCategorias;

  CrearProductoRequest({
    required this.idUnidad,
    this.codigo,
    required this.nombre,
    required this.precio,
    this.stockMinimo = 0,
    this.rutaImagen,
    this.idCategorias = const [],
  }) {
    if (nombre.trim().isEmpty) {
      throw ValidationException('El nombre del producto es obligatorio');
    }
    if (precio < 0) {
      throw ValidationException('El precio no puede ser negativo');
    }
    if (stockMinimo < 0) {
      throw ValidationException('El stock minimo no puede ser negativo');
    }
  }
}
