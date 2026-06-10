class AppException implements Exception {
  final String mensaje;
  final String? descripcion;
  final String? codigo;

  AppException(this.mensaje, {this.descripcion, this.codigo});

  @override
  String toString() => codigo != null ? '[$codigo] $mensaje' : mensaje;
}
