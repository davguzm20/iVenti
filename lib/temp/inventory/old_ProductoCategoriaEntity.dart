class ProductoCategoriaEntity {
  final int idProducto;
  final int idCategoria;
  final DateTime? fechaAsignacion;

  ProductoCategoriaEntity({
    required this.idProducto,
    required this.idCategoria,
    this.fechaAsignacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_producto': idProducto,
      'id_categoria': idCategoria,
    };
  }

  factory ProductoCategoriaEntity.fromMap(Map<String, dynamic> map) {
    return ProductoCategoriaEntity(
      idProducto: map['id_producto'] as int,
      idCategoria: map['id_categoria'] as int,
    );
  }

  @override
  String toString() => 'ProductoCategoriaEntity(producto: $idProducto, categoria: $idCategoria)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductoCategoriaEntity &&
        other.idProducto == idProducto &&
        other.idCategoria == idCategoria;
  }

  @override
  int get hashCode => idProducto.hashCode ^ idCategoria.hashCode;
}
