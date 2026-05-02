class UnidadEntity {
  final int? idUnidad;
  final String nombre;
  final String abreviatura;
  final bool esActivo;
  final DateTime? fechaCreacion;

  UnidadEntity({
    this.idUnidad,
    required this.nombre,
    required this.abreviatura,
    this.esActivo = true,
    this.fechaCreacion,
  });

  UnidadEntity copyWith({
    int? idUnidad,
    String? nombre,
    String? abreviatura,
    bool? esActivo,
    DateTime? fechaCreacion,
  }) {
    return UnidadEntity(
      idUnidad: idUnidad ?? this.idUnidad,
      nombre: nombre ?? this.nombre,
      abreviatura: abreviatura ?? this.abreviatura,
      esActivo: esActivo ?? this.esActivo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_unidad': idUnidad,
      'nombre': nombre,
      'abreviatura': abreviatura,
      'es_activo': esActivo ? 1 : 0,
    };
  }

  factory UnidadEntity.fromMap(Map<String, dynamic> map) {
    return UnidadEntity(
      idUnidad: map['id_unidad'] as int?,
      nombre: map['nombre'] as String,
      abreviatura: map['abreviatura'] as String,
      esActivo: (map['es_activo'] as int?) == 1,
    );
  }

  @override
  String toString() => 'UnidadEntity(id: $idUnidad, nombre: $nombre, abrev: $abreviatura)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UnidadEntity && other.idUnidad == idUnidad;
  }

  @override
  int get hashCode => idUnidad.hashCode;
}
