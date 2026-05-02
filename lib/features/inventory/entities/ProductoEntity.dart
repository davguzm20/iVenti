class ProductoEntity {
  final int? idProducto;
  final int idUnidad;
  final String? codigo;
  final String nombre;
  final double precio;
  final int stockActual;
  final int stockMinimo;
  final String? rutaImagen;
  final bool esActivo;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  ProductoEntity({
    this.idProducto,
    required this.idUnidad,
    this.codigo,
    required this.nombre,
    required this.precio,
    required this.stockActual,
    required this.stockMinimo,
    this.rutaImagen,
    this.esActivo = true,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
