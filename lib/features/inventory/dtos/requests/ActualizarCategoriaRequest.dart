import 'package:iventi/shared/exceptions/ValidationException.dart';

class ActualizarCategoriaRequest {
  final int idCategoria;
  final String nombre;

  ActualizarCategoriaRequest({
    required this.idCategoria,
    required this.nombre,
  }) {
    if (nombre.trim().isEmpty) {
      throw ValidationException('El nombre de la categoria es obligatorio');
    }
  }
}
