class ClienteEntity {
  final int? idCliente;
  final String? dni;
  final String nombres;
  final String apellidos;
  final String? email;
  final String? telefono;
  final bool esDeudor;
  final bool esActivo;
  final DateTime creadoEn;
  final DateTime? actualizadoEn;

  ClienteEntity({
    this.idCliente,
    this.dni,
    required this.nombres,
    required this.apellidos,
    this.email,
    this.telefono,
    this.esDeudor = false,
    this.esActivo = true,
    required this.creadoEn,
    this.actualizadoEn,
  });
}
