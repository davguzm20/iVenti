class LoteEntity {
  final int? idLote;
  final int idProducto;
  final int cantidadActual;
  final int cantidadComprada;
  final int cantidadPerdida;
  final double precioCompra;
  final DateTime fechaCompra;
  final DateTime? fechaVencimiento;
  final bool esActivo;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  LoteEntity({
    this.idLote,
    required this.idProducto,
    required this.cantidadActual,
    required this.cantidadComprada,
    this.cantidadPerdida = 0,
    required this.precioCompra,
    required this.fechaCompra,
    this.fechaVencimiento,
    this.esActivo = true,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  LoteEntity copyWith({
    int? idLote,
    int? idProducto,
    int? cantidadActual,
    int? cantidadComprada,
    int? cantidadPerdida,
    double? precioCompra,
    DateTime? fechaCompra,
    DateTime? fechaVencimiento,
    bool? esActivo,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return LoteEntity(
      idLote: idLote ?? this.idLote,
      idProducto: idProducto ?? this.idProducto,
      cantidadActual: cantidadActual ?? this.cantidadActual,
      cantidadComprada: cantidadComprada ?? this.cantidadComprada,
      cantidadPerdida: cantidadPerdida ?? this.cantidadPerdida,
      precioCompra: precioCompra ?? this.precioCompra,
      fechaCompra: fechaCompra ?? this.fechaCompra,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      esActivo: esActivo ?? this.esActivo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_lote': idLote,
      'id_producto': idProducto,
      'cantidad_actual': cantidadActual,
      'cantidad_comprada': cantidadComprada,
      'cantidad_perdida': cantidadPerdida,
      'precio_compra': precioCompra,
      'fecha_compra': fechaCompra.toIso8601String().split('T').first,
      'fecha_vencimiento': fechaVencimiento?.toIso8601String().split('T').first,
      'es_activo': esActivo ? 1 : 0,
    };
  }

  factory LoteEntity.fromMap(Map<String, dynamic> map) {
    return LoteEntity(
      idLote: map['id_lote'] as int?,
      idProducto: map['id_producto'] as int,
      cantidadActual: map['cantidad_actual'] as int,
      cantidadComprada: map['cantidad_comprada'] as int,
      cantidadPerdida: map['cantidad_perdida'] as int? ?? 0,
      precioCompra: (map['precio_compra'] as num).toDouble(),
      fechaCompra: DateTime.parse(map['fecha_compra'] as String),
      fechaVencimiento: map['fecha_vencimiento'] != null
          ? DateTime.parse(map['fecha_vencimiento'] as String)
          : null,
      esActivo: (map['es_activo'] as int?) == 1,
    );
  }

  @override
  String toString() {
    return 'LoteEntity(id: $idLote, producto: $idProducto, cantidad: $cantidadActual, vencimiento: $fechaVencimiento)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoteEntity && other.idLote == idLote && other.idProducto == idProducto;
  }

  @override
  int get hashCode => idLote.hashCode ^ idProducto.hashCode;
}
