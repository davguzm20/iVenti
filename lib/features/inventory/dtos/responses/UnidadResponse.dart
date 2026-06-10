class UnidadResponse {
  final int idUnidad;
  final String nombre;
  final String abreviatura;
  final bool esActivo;
  final DateTime creadoEn;

  UnidadResponse({
    required this.idUnidad,
    required this.nombre,
    required this.abreviatura,
    required this.esActivo,
    required this.creadoEn,
  });
}
