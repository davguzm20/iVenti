class ProductoEntity {
  final int? idProducto;
  final int? idUnidad;
  final String? codigoProducto;
  final String nombreProducto;
  final double precioProducto;
  final double stockActual;
  final double stockMinimo;
  final String? rutaImagen;
  final bool esActivo;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  ProductoEntity({
    this.idProducto,
    this.idUnidad,
    this.codigoProducto,
    required this.nombreProducto,
    required this.precioProducto,
    this.stockActual = 0,
    this.stockMinimo = 5,
    this.rutaImagen,
    this.esActivo = true,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  ProductoEntity copyWith({
    int? idProducto,
    int? idUnidad,
    String? codigoProducto,
    String? nombreProducto,
    double? precioProducto,
    double? stockActual,
    double? stockMinimo,
    String? rutaImagen,
    bool? esActivo,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return ProductoEntity(
      idProducto: idProducto ?? this.idProducto,
      idUnidad: idUnidad ?? this.idUnidad,
      codigoProducto: codigoProducto ?? this.codigoProducto,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      precioProducto: precioProducto ?? this.precioProducto,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      rutaImagen: rutaImagen ?? this.rutaImagen,
      esActivo: esActivo ?? this.esActivo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_producto': idProducto,
      'id_unidad': idUnidad,
      'codigo': codigoProducto,
      'nombre': nombreProducto,
      'precio': precioProducto,
      'stock_actual': stockActual,
      'stock_minimo': stockMinimo,
      'ruta_imagen': rutaImagen,
      'es_activo': esActivo ? 1 : 0,
    };
  }

  factory ProductoEntity.fromMap(Map<String, dynamic> map) {
    return ProductoEntity(
      idProducto: map['id_producto'] as int?,
      idUnidad: map['id_unidad'] as int?,
      codigoProducto: map['codigo'] as String?,
      nombreProducto: map['nombre'] as String,
      precioProducto: (map['precio'] as num).toDouble(),
      stockActual: (map['stock_actual'] as num?)?.toDouble() ?? 0,
      stockMinimo: (map['stock_minimo'] as num?)?.toDouble() ?? 5,
      rutaImagen: map['ruta_imagen'] as String?,
      esActivo: (map['es_activo'] as int?) == 1,
    );
  }

  @override
  String toString() {
    return 'ProductoEntity(id: $idProducto, nombre: $nombreProducto, precio: $precioProducto, stock: $stockActual)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductoEntity && other.idProducto == idProducto;
  }

  @override
  int get hashCode => idProducto.hashCode;
}
