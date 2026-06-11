import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';

void main() {
  final fecha = DateTime(2024, 6, 10);

  group('ClienteEntity', () {
    test('debe crear con dni string', () {
      final entity = ClienteEntity(
        nombres: 'Juan',
        dni: '12345678',
        creadoEn: fecha,
      );

      expect(entity.dni, '12345678');
    });

    test('debe crear con dni null', () {
      final entity = ClienteEntity(
        nombres: 'Juan',
        dni: null,
        creadoEn: fecha,
      );

      expect(entity.dni, isNull);
    });

    test('debe crear solo con campos minimos requeridos', () {
      final entity = ClienteEntity(
        nombres: 'Maria',
        creadoEn: fecha,
      );

      expect(entity.nombres, 'Maria');
      expect(entity.dni, isNull);
      expect(entity.email, isNull);
      expect(entity.telefono, isNull);
      expect(entity.idCliente, isNull);
      expect(entity.actualizadoEn, isNull);
    });

    test('debe tener esDeudor false por default', () {
      final entity = ClienteEntity(
        nombres: 'Juan',
        creadoEn: fecha,
      );

      expect(entity.esDeudor, false);
    });

    test('debe tener esActivo true por default', () {
      final entity = ClienteEntity(
        nombres: 'Juan',
        creadoEn: fecha,
      );

      expect(entity.esActivo, true);
    });

    test('debe crear con todos los campos', () {
      final entity = ClienteEntity(
        idCliente: 1,
        dni: '87654321',
        nombres: 'Carlos',
        email: 'carlos@test.com',
        telefono: '999111222',
        esDeudor: true,
        esActivo: true,
        creadoEn: fecha,
        actualizadoEn: fecha,
      );

      expect(entity.idCliente, 1);
      expect(entity.dni, '87654321');
      expect(entity.nombres, 'Carlos');
      expect(entity.email, 'carlos@test.com');
      expect(entity.telefono, '999111222');
      expect(entity.esDeudor, true);
      expect(entity.esActivo, true);
      expect(entity.creadoEn, fecha);
      expect(entity.actualizadoEn, fecha);
    });

    test('no debe tener campo apellidos', () {
      final entity = ClienteEntity(
        nombres: 'Juan',
        creadoEn: fecha,
      );

      expect(() => (entity as dynamic).apellidos, throwsNoSuchMethodError);
    });

    test('no debe tener dniHash', () {
      final entity = ClienteEntity(
        nombres: 'Juan',
        creadoEn: fecha,
      );

      expect(() => (entity as dynamic).dniHash, throwsNoSuchMethodError);
    });

    test('no debe tener dniMasked', () {
      final entity = ClienteEntity(
        nombres: 'Juan',
        creadoEn: fecha,
      );

      expect(() => (entity as dynamic).dniMasked, throwsNoSuchMethodError);
    });
  });
}
