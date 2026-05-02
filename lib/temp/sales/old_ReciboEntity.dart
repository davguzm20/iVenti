class ReciboEntity {
  final int? idRecibo;
  final int idVenta;
  final int idUsuario;
  final double montoCancelado;
  final DateTime pagadoEn;
  final DateTime? fechaCreacion;

  ReciboEntity({
    this.idRecibo,
    required this.idVenta,
    required this.idUsuario,
    required this.montoCancelado,
    required this.pagadoEn,
    this.fechaCreacion,
  });

  ReciboEntity copyWith({
    int? idRecibo,
    int? idVenta,
    int? idUsuario,
    double? montoCancelado,
    DateTime? pagadoEn,
    DateTime? fechaCreacion,
  }) {
    return ReciboEntity(
      idRecibo: idRecibo ?? this.idRecibo,
      idVenta: idVenta ?? this.idVenta,
      idUsuario: idUsuario ?? this.idUsuario,
      montoCancelado: montoCancelado ?? this.montoCancelado,
      pagadoEn: pagadoEn ?? this.pagadoEn,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_recibo': idRecibo,
      'id_venta': idVenta,
      'id_usuario': idUsuario,
      'monto_cancelado': montoCancelado,
      'pagado_en': pagadoEn.toIso8601String(),
      'fecha_creacion': fechaCreacion?.toIso8601String(),
    };
  }

  factory ReciboEntity.fromMap(Map<String, dynamic> map) {
    return ReciboEntity(
      idRecibo: map['id_recibo'] as int?,
      idVenta: map['id_venta'] as int,
      idUsuario: map['id_usuario'] as int,
      montoCancelado: (map['monto_cancelado'] as num).toDouble(),
      pagadoEn: map['pagado_en'] != null
          ? DateTime.parse(map['pagado_en'] as String)
          : DateTime.now(),
      fechaCreacion: map['fecha_creacion'] != null
          ? DateTime.parse(map['fecha_creacion'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'ReciboEntity(id: $idRecibo, venta: $idVenta, monto: $montoCancelado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReciboEntity && other.idRecibo == idRecibo;
  }

  @override
  int get hashCode => idRecibo.hashCode;
}
