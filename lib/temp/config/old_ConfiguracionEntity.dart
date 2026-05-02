class ConfiguracionEntity {
  final int? idConfiguracion;
  final int idUsuario;
  final String clave;
  final String valor;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  ConfiguracionEntity({
    this.idConfiguracion,
    required this.idUsuario,
    required this.clave,
    required this.valor,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  ConfiguracionEntity copyWith({
    int? idConfiguracion,
    int? idUsuario,
    String? clave,
    String? valor,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return ConfiguracionEntity(
      idConfiguracion: idConfiguracion ?? this.idConfiguracion,
      idUsuario: idUsuario ?? this.idUsuario,
      clave: clave ?? this.clave,
      valor: valor ?? this.valor,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_configuracion': idConfiguracion,
      'id_usuario': idUsuario,
      'clave': clave,
      'valor': valor,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }

  factory ConfiguracionEntity.fromMap(Map<String, dynamic> map) {
    return ConfiguracionEntity(
      idConfiguracion: map['id_configuracion'] as int?,
      idUsuario: map['id_usuario'] as int,
      clave: map['clave'] as String,
      valor: map['valor'] as String,
      fechaCreacion: map['fecha_creacion'] != null
          ? DateTime.parse(map['fecha_creacion'] as String)
          : null,
      fechaActualizacion: map['fecha_actualizacion'] != null
          ? DateTime.parse(map['fecha_actualizacion'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'ConfiguracionEntity(id: $idConfiguracion, clave: $clave, valor: $valor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConfiguracionEntity &&
        other.idConfiguracion == idConfiguracion;
  }

  @override
  int get hashCode => idConfiguracion.hashCode;
}

class AuditoriaEntity {
  final int? idAuditoria;
  final int? idUsuario;
  final String tabla;
  final int registroId;
  final String operacion;
  final DateTime fechaAuditoria;
  final String? ipOrigen;
  final String? dispositivo;

  AuditoriaEntity({
    this.idAuditoria,
    this.idUsuario,
    required this.tabla,
    required this.registroId,
    required this.operacion,
    required this.fechaAuditoria,
    this.ipOrigen,
    this.dispositivo,
  });

  AuditoriaEntity copyWith({
    int? idAuditoria,
    int? idUsuario,
    String? tabla,
    int? registroId,
    String? operacion,
    DateTime? fechaAuditoria,
    String? ipOrigen,
    String? dispositivo,
  }) {
    return AuditoriaEntity(
      idAuditoria: idAuditoria ?? this.idAuditoria,
      idUsuario: idUsuario ?? this.idUsuario,
      tabla: tabla ?? this.tabla,
      registroId: registroId ?? this.registroId,
      operacion: operacion ?? this.operacion,
      fechaAuditoria: fechaAuditoria ?? this.fechaAuditoria,
      ipOrigen: ipOrigen ?? this.ipOrigen,
      dispositivo: dispositivo ?? this.dispositivo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_auditoria': idAuditoria,
      'id_usuario': idUsuario,
      'tabla': tabla,
      'registro_id': registroId,
      'operacion': operacion,
      'fecha_auditoria': fechaAuditoria.toIso8601String(),
      'ip_origen': ipOrigen,
      'dispositivo': dispositivo,
    };
  }

  factory AuditoriaEntity.fromMap(Map<String, dynamic> map) {
    return AuditoriaEntity(
      idAuditoria: map['id_auditoria'] as int?,
      idUsuario: map['id_usuario'] as int?,
      tabla: map['tabla'] as String,
      registroId: map['registro_id'] as int,
      operacion: map['operacion'] as String,
      fechaAuditoria: DateTime.parse(map['fecha_auditoria'] as String),
      ipOrigen: map['ip_origen'] as String?,
      dispositivo: map['dispositivo'] as String?,
    );
  }

  @override
  String toString() {
    return 'AuditoriaEntity(id: $idAuditoria, tabla: $tabla, operacion: $operacion)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuditoriaEntity && other.idAuditoria == idAuditoria;
  }

  @override
  int get hashCode => idAuditoria.hashCode;
}
