import 'package:iventi/features/auth/enums/TipoRol.dart';

class UsuarioResponse {
  final int idUsuario;
  final TipoRol rol;
  final String nombre;
  final String email;
  final bool esActivo;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  UsuarioResponse({
    required this.idUsuario,
    required this.rol,
    required this.nombre,
    required this.email,
    required this.esActivo,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
