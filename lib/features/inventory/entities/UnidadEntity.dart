class UnidadEntity {
  final int? idUnidad;
  final String nombre;
  final String abreviatura;
  final bool esActivo;
  final DateTime creadoEn;

  UnidadEntity({
    this.idUnidad,
    required this.nombre,
    required this.abreviatura,
    this.esActivo = true,
    required this.creadoEn,
  });
}
