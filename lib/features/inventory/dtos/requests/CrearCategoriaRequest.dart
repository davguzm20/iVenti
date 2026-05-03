import 'package:iventi/shared/exceptions/ValidationException.dart';

class CrearCategoriaRequest {
  final String nombre;

  CrearCategoriaRequest({required this.nombre}) {
    if (nombre.trim().isEmpty) {
      throw ValidationException('El nombre de la categoria es obligatorio');
    }
  }
}
