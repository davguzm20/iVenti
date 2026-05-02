class ClienteEntity {
  final int? idCliente;
  final String nombreCliente;
  final String? dniCliente;
  final String? correoCliente;
  final String? telefono;
  final bool esDeudor;
  final bool esActivo;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  ClienteEntity({
    this.idCliente,
    required this.nombreCliente,
    this.dniCliente,
    this.correoCliente,
    this.telefono,
    this.esDeudor = false,
    this.esActivo = true,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  ClienteEntity copyWith({
    int? idCliente,
    String? nombreCliente,
    String? dniCliente,
    String? correoCliente,
    String? telefono,
    bool? esDeudor,
    bool? esActivo,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return ClienteEntity(
      idCliente: idCliente ?? this.idCliente,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      dniCliente: dniCliente ?? this.dniCliente,
      correoCliente: correoCliente ?? this.correoCliente,
      telefono: telefono ?? this.telefono,
      esDeudor: esDeudor ?? this.esDeudor,
      esActivo: esActivo ?? this.esActivo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_cliente': idCliente,
      'nombre_cliente': nombreCliente,
      'dni': dniCliente,
      'email': correoCliente,
      'telefono': telefono,
      'es_deudor': esDeudor ? 1 : 0,
      'es_activo': esActivo ? 1 : 0,
    };
  }

  factory ClienteEntity.fromMap(Map<String, dynamic> map) {
    return ClienteEntity(
      idCliente: map['id_cliente'] as int?,
      nombreCliente: map['nombres'] as String,
      dniCliente: map['dni'] as String?,
      correoCliente: map['email'] as String?,
      telefono: map['telefono'] as String?,
      esDeudor: (map['es_deudor'] as int?) == 1,
      esActivo: (map['es_activo'] as int?) == 1,
    );
  }

  @override
  String toString() {
    return 'ClienteEntity(id: $idCliente, nombre: $nombreCliente, dni: $dniCliente, email: $correoCliente)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClienteEntity && other.idCliente == idCliente;
  }

  @override
  int get hashCode => idCliente.hashCode;
}
