import 'package:iventi/shared/exceptions/ValidationException.dart';

class CrearConfiguracionRequest {
  final int idUsuario;
  final String clave;
  final String valor;

  CrearConfiguracionRequest({required this.idUsuario, required this.clave, required this.valor}) {
    if (clave.trim().isEmpty) throw ValidationException('La clave de configuracion es obligatoria');
    if (valor.trim().isEmpty) throw ValidationException('El valor de configuracion es obligatorio');
  }
}
