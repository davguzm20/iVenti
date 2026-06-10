class ConfiguracionResponse {
  final int idConfiguracion;
  final int idUsuario;
  final String clave;
  final String valor;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  ConfiguracionResponse({
    required this.idConfiguracion,
    required this.idUsuario,
    required this.clave,
    required this.valor,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
