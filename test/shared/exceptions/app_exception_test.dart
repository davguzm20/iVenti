import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/shared/exceptions/AppException.dart';
import 'package:iventi/shared/exceptions/AuthenticationException.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NetworkException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';

void main() {
  group('AppException', () {
    test('debe crear con mensaje y descripcion', () {
      final ex = AppException('Error', descripcion: 'Descripcion');
      expect(ex.mensaje, 'Error');
      expect(ex.descripcion, 'Descripcion');
    });

    test('debe tener descripcion null por defecto', () {
      final ex = AppException('Error');
      expect(ex.descripcion, isNull);
    });

    test('debe tener codigo null por defecto', () {
      final ex = AppException('Error');
      expect(ex.codigo, isNull);
    });

    test('toString debe retornar mensaje sin codigo', () {
      final ex = AppException('Error', descripcion: 'Desc');
      expect(ex.toString(), 'Error');
    });

    test('toString debe incluir codigo si existe', () {
      final ex = AppException('Error', codigo: 'E001');
      expect(ex.toString(), '[E001] Error');
    });

    test('debe implementar Exception', () {
      final ex = AppException('Error');
      expect(ex, isA<Exception>());
    });
  });

  group('AuthenticationException', () {
    test('debe heredar de AppException', () {
      final ex = AuthenticationException('No autorizado');
      expect(ex, isA<AppException>());
      expect(ex.mensaje, 'No autorizado');
    });
  });

  group('BusinessException', () {
    test('debe heredar de AppException', () {
      final ex = BusinessException('Regla de negocio');
      expect(ex, isA<AppException>());
      expect(ex.mensaje, 'Regla de negocio');
    });

    test('debe aceptar descripcion', () {
      final ex = BusinessException('Error', descripcion: 'Detalle');
      expect(ex.descripcion, 'Detalle');
    });
  });

  group('DatabaseException', () {
    test('debe heredar de AppException', () {
      final ex = DatabaseException('Error de BD');
      expect(ex, isA<AppException>());
      expect(ex.mensaje, 'Error de BD');
    });
  });

  group('NetworkException', () {
    test('debe heredar de AppException', () {
      final ex = NetworkException('Sin conexion');
      expect(ex, isA<AppException>());
      expect(ex.mensaje, 'Sin conexion');
    });
  });

  group('NotFoundException', () {
    test('debe heredar de AppException', () {
      final ex = NotFoundException('No encontrado');
      expect(ex, isA<AppException>());
      expect(ex.mensaje, 'No encontrado');
    });
  });

  group('ValidationException', () {
    test('debe heredar de AppException', () {
      final ex = ValidationException('Dato invalido');
      expect(ex, isA<AppException>());
      expect(ex.mensaje, 'Dato invalido');
    });

    test('debe aceptar descripcion', () {
      final ex = ValidationException('Error', descripcion: 'Campo X');
      expect(ex.descripcion, 'Campo X');
    });
  });
}
