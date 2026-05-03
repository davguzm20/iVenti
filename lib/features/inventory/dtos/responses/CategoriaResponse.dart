class CategoriaResponse {
  final int idCategoria;
  final String nombre;
  final bool esActivo;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  CategoriaResponse({
    required this.idCategoria,
    required this.nombre,
    required this.esActivo,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
