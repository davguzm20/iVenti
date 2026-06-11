class ClienteResponse {
  final int idCliente;
  final String? dni;
  final String nombres;
  final String? email;
  final String? telefono;
  final bool esDeudor;
  final bool esActivo;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  ClienteResponse({
    required this.idCliente,
    this.dni,
    required this.nombres,
    this.email,
    this.telefono,
    required this.esDeudor,
    required this.esActivo,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
