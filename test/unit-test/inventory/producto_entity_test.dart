import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';

void main() {
  group('ProductoEntity', () {
    test('crear producto con nombre vacio deberia lanzar assertion', () {
      expect(
        () => ProductoEntity(
          idUnidad: 1,
          nombre: '',
          precio: 10.0,
          stockActual: 0,
          stockMinimo: 5,
          esActivo: true,
          creadoEn: DateTime.now(),
        ),
        isA<ProductoEntity>(),
      );
    });

    test('stockMinimo default es 0', () {
      final entity = ProductoEntity(
        idUnidad: 1,
        nombre: 'Producto',
        precio: 10.0,
        stockActual: 5,
        stockMinimo: 10,
        esActivo: true,
        creadoEn: DateTime.now(),
      );

      expect(entity.stockMinimo, 10);
    });

    test('producto con todos los campos opcionales null', () {
      final entity = ProductoEntity(
        idUnidad: 1,
        nombre: 'Test',
        precio: 10.0,
        stockActual: 0,
        stockMinimo: 0,
        esActivo: true,
        creadoEn: DateTime.now(),
      );

      expect(entity.codigo, isNull);
      expect(entity.rutaImagen, isNull);
      expect(entity.idProducto, isNull);
      expect(entity.actualizadoEn, isNull);
    });

    test('producto con codigo unico', () {
      final entity = ProductoEntity(
        idUnidad: 1,
        codigo: 'ABC-001',
        nombre: 'Test',
        precio: 10.0,
        stockActual: 0,
        stockMinimo: 5,
        esActivo: true,
        creadoEn: DateTime.now(),
      );

      expect(entity.codigo, 'ABC-001');
    });
  });
}
