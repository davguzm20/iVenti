class CategoriaEntity {
  final int? idCategoria;
  final String nombre;
  final bool esActivo;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  CategoriaEntity({
    this.idCategoria,
    required this.nombre,
    this.esActivo = true,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
