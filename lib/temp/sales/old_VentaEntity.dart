class VentaEntity {
  final int? idVenta;
  final int idCliente;
  final int idUsuario;
  final DateTime vendidoEn;
  final double montoTotal;
  final double montoCancelado;
  final bool esCredito;
  final String estado;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  VentaEntity({
    this.idVenta,
    required this.idCliente,
    required this.idUsuario,
    required this.vendidoEn,
    required this.montoTotal,
    this.montoCancelado = 0,
    this.esCredito = false,
    this.estado = 'PENDIENTE',
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  VentaEntity copyWith({
    int? idVenta,
    int? idCliente,
    int? idUsuario,
    DateTime? vendidoEn,
    double? montoTotal,
    double? montoCancelado,
    bool? esCredito,
    String? estado,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return VentaEntity(
      idVenta: idVenta ?? this.idVenta,
      idCliente: idCliente ?? this.idCliente,
      idUsuario: idUsuario ?? this.idUsuario,
      vendidoEn: vendidoEn ?? this.vendidoEn,
      montoTotal: montoTotal ?? this.montoTotal,
      montoCancelado: montoCancelado ?? this.montoCancelado,
      esCredito: esCredito ?? this.esCredito,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_venta': idVenta,
      'id_cliente': idCliente,
      'id_usuario': idUsuario,
      'monto_total': montoTotal,
      'monto_cancelado': montoCancelado,
      'es_credito': esCredito ? 1 : 0,
      'estado': estado,
    };
  }

  factory VentaEntity.fromMap(Map<String, dynamic> map) {
    return VentaEntity(
      idVenta: map['id_venta'] as int?,
      idCliente: map['id_cliente'] as int,
      idUsuario: map['id_usuario'] as int,
      vendidoEn: map['vendido_en'] != null
          ? DateTime.parse(map['vendido_en'] as String)
          : DateTime.now(),
      montoTotal: (map['monto_total'] as num).toDouble(),
      montoCancelado: (map['monto_cancelado'] as num?)?.toDouble() ?? 0,
      esCredito: (map['es_credito'] as int?) == 1,
      estado: map['estado'] as String? ?? 'PENDIENTE',
    );
  }

  @override
  String toString() {
    return 'VentaEntity(id: $idVenta, cliente: $idCliente, total: $montoTotal, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VentaEntity && other.idVenta == idVenta;
  }

  @override
  int get hashCode => idVenta.hashCode;
}
