class AppException implements Exception {
  final String mensaje;
  final String? codigo;

  AppException(this.mensaje, {this.codigo});

  @override
  String toString() => codigo != null ? '[$codigo] $mensaje' : mensaje;
}
