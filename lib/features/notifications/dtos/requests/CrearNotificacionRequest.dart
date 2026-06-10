import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';

class CrearNotificacionRequest {
  final int idUsuario;
  final int? idProducto;
  final int? idLote;
  final TipoNotificacion tipo;
  final String titulo;
  final String contenido;

  CrearNotificacionRequest({required this.idUsuario, this.idProducto, this.idLote, required this.tipo, required this.titulo, required this.contenido}) {
    if (titulo.trim().isEmpty) throw ValidationException('El titulo es obligatorio');
    if (contenido.trim().isEmpty) throw ValidationException('El contenido es obligatorio');
  }
}
