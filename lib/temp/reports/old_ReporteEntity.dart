class ReporteEntity {
  final int? idReporte;
  final int idUsuario;
  final String tipoReporte;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String formato;
  final String? rutaArchivo;
  final DateTime? fechaGeneracion;

  ReporteEntity({
    this.idReporte,
    required this.idUsuario,
    required this.tipoReporte,
    required this.fechaInicio,
    required this.fechaFin,
    this.formato = 'PDF',
    this.rutaArchivo,
    this.fechaGeneracion,
  });

  ReporteEntity copyWith({
    int? idReporte,
    int? idUsuario,
    String? tipoReporte,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? formato,
    String? rutaArchivo,
    DateTime? fechaGeneracion,
  }) {
    return ReporteEntity(
      idReporte: idReporte ?? this.idReporte,
      idUsuario: idUsuario ?? this.idUsuario,
      tipoReporte: tipoReporte ?? this.tipoReporte,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      formato: formato ?? this.formato,
      rutaArchivo: rutaArchivo ?? this.rutaArchivo,
      fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_reporte': idReporte,
      'id_usuario': idUsuario,
      'tipo_reporte': tipoReporte,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin.toIso8601String(),
      'formato': formato,
      'ruta_archivo': rutaArchivo,
      'fecha_generacion': fechaGeneracion?.toIso8601String(),
    };
  }

  factory ReporteEntity.fromMap(Map<String, dynamic> map) {
    return ReporteEntity(
      idReporte: map['id_reporte'] as int?,
      idUsuario: map['id_usuario'] as int,
      tipoReporte: map['tipo_reporte'] as String,
      fechaInicio: DateTime.parse(map['fecha_inicio'] as String),
      fechaFin: DateTime.parse(map['fecha_fin'] as String),
      formato: map['formato'] as String? ?? 'PDF',
      rutaArchivo: map['ruta_archivo'] as String?,
      fechaGeneracion: map['fecha_generacion'] != null
          ? DateTime.parse(map['fecha_generacion'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'ReporteEntity(id: $idReporte, tipo: $tipoReporte, desde: $fechaInicio, hasta: $fechaFin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReporteEntity && other.idReporte == idReporte;
  }

  @override
  int get hashCode => idReporte.hashCode;
}
