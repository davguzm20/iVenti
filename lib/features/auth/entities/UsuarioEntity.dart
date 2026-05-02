import '../enums/TipoRol.dart';

class UsuarioEntity {
  final int? idUsuario;
  final TipoRol idRol;
  final String nombre;
  final String email;
  final String pin;
  final bool esActivo;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  UsuarioEntity({
    this.idUsuario,
    required this.idRol,
    required this.nombre,
    required this.email,
    required this.pin,
    this.esActivo = true,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
