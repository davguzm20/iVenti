class UsuarioEntity {
  final int? idUsuario;
  final int? idRol;
  final String nombre;
  final String email;
  final String? pin;
  final bool esActivo;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  UsuarioEntity({
    this.idUsuario,
    this.idRol,
    required this.nombre,
    required this.email,
    this.pin,
    this.esActivo = true,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  UsuarioEntity copyWith({
    int? idUsuario,
    int? idRol,
    String? nombre,
    String? email,
    String? pin,
    bool? esActivo,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return UsuarioEntity(
      idUsuario: idUsuario ?? this.idUsuario,
      idRol: idRol ?? this.idRol,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      pin: pin ?? this.pin,
      esActivo: esActivo ?? this.esActivo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'id_rol': idRol,
      'nombre': nombre,
      'email': email,
      'pin': pin,
      'es_activo': esActivo ? 1 : 0,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }

  factory UsuarioEntity.fromMap(Map<String, dynamic> map) {
    return UsuarioEntity(
      idUsuario: map['id_usuario'] as int?,
      idRol: map['id_rol'] as int?,
      nombre: map['nombre'] as String,
      email: map['email'] as String,
      pin: map['pin'] as String?,
      esActivo: (map['es_activo'] as int?) == 1,
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
    return 'UsuarioEntity(id: $idUsuario, nombre: $nombre, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsuarioEntity && other.idUsuario == idUsuario;
  }

  @override
  int get hashCode => idUsuario.hashCode;
}
