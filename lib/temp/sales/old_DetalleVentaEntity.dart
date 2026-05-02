class DetalleVentaEntity {
  final int? idDetalleVenta;
  final int idVenta;
  final int idLote;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final double descuento;
  final DateTime? fechaCreacion;

  DetalleVentaEntity({
    this.idDetalleVenta,
    required this.idVenta,
    required this.idLote,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.descuento = 0,
    this.fechaCreacion,
  });

  DetalleVentaEntity copyWith({
    int? idDetalleVenta,
    int? idVenta,
    int? idLote,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
    double? descuento,
    DateTime? fechaCreacion,
  }) {
    return DetalleVentaEntity(
      idDetalleVenta: idDetalleVenta ?? this.idDetalleVenta,
      idVenta: idVenta ?? this.idVenta,
      idLote: idLote ?? this.idLote,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      subtotal: subtotal ?? this.subtotal,
      descuento: descuento ?? this.descuento,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_detalle_venta': idDetalleVenta,
      'id_venta': idVenta,
      'id_lote': idLote,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
      'subtotal': subtotal,
      'descuento': descuento,
    };
  }

  factory DetalleVentaEntity.fromMap(Map<String, dynamic> map) {
    return DetalleVentaEntity(
      idDetalleVenta: map['id_detalle_venta'] as int?,
      idVenta: map['id_venta'] as int,
      idLote: map['id_lote'] as int,
      cantidad: map['cantidad'] as int,
      precioUnitario: (map['precio_unitario'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
      descuento: (map['descuento'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  String toString() {
    return 'DetalleVentaEntity(id: $idDetalleVenta, venta: $idVenta, cantidad: $cantidad, subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DetalleVentaEntity && other.idDetalleVenta == idDetalleVenta;
  }

  @override
  int get hashCode => idDetalleVenta.hashCode;
}
