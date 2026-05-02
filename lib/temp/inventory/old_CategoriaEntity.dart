class CategoriaEntity {
  final int? idCategoria;
  final String nombreCategoria;
  final bool esActivo;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  CategoriaEntity({
    this.idCategoria,
    required this.nombreCategoria,
    this.esActivo = true,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  CategoriaEntity copyWith({
    int? idCategoria,
    String? nombreCategoria,
    bool? esActivo,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return CategoriaEntity(
      idCategoria: idCategoria ?? this.idCategoria,
      nombreCategoria: nombreCategoria ?? this.nombreCategoria,
      esActivo: esActivo ?? this.esActivo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_categoria': idCategoria,
      'nombre': nombreCategoria,
      'es_activo': esActivo ? 1 : 0,
    };
  }

  factory CategoriaEntity.fromMap(Map<String, dynamic> map) {
    return CategoriaEntity(
      idCategoria: map['id_categoria'] as int?,
      nombreCategoria: map['nombre'] as String,
      esActivo: (map['es_activo'] as int?) == 1,
    );
  }

  @override
  String toString() => 'CategoriaEntity(id: $idCategoria, nombre: $nombreCategoria)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoriaEntity && other.idCategoria == idCategoria;
  }

  @override
  int get hashCode => idCategoria.hashCode;
}
