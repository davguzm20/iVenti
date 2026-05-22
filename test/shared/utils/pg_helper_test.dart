import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/shared/utils/PgHelper.dart';

void main() {
  group('PgHelper.string', () {
    test('debe devolver string si recibe un String', () {
      expect(PgHelper.string('hola'), 'hola');
    });

    test('debe devolver string vacio si recibe string vacio', () {
      expect(PgHelper.string(''), '');
    });

    test('debe decodificar List<int> utf8', () {
      final bytes = utf8.encode('café');
      expect(PgHelper.string(bytes), 'café');
    });

    test('debe decodificar List<int> con acentos', () {
      final bytes = utf8.encode('acción y efectos');
      expect(PgHelper.string(bytes), 'acción y efectos');
    });

    test('debe devolver string vacio si recibe null', () {
      expect(PgHelper.string(null), 'null');
    });

    test('debe devolver string vacio si recibe lista vacia', () {
      expect(PgHelper.string(<int>[]), '');
    });

    test('debe decodificar numeros', () {
      final bytes = utf8.encode('12345');
      expect(PgHelper.string(bytes), '12345');
    });

    test('debe decodificar caracteres especiales', () {
      final bytes = utf8.encode('ñoño');
      expect(PgHelper.string(bytes), 'ñoño');
    });

    test('debe manejar int directamente', () {
      expect(PgHelper.string(42), '42');
    });

    test('debe manejar double directamente', () {
      expect(PgHelper.string(3.14), '3.14');
    });
  });
}
