import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';
import 'package:iventi/features/clients/dtos/requests/ActualizarClienteRequest.dart';

void main() {
  group('CrearClienteRequest validacion', () {
    test('DNI de 8 digitos es valido', () {
      final request = CrearClienteRequest(nombres: 'Juan', dni: '12345678');
      expect(request.dni, '12345678');
    });

    test('DNI de 7 digitos es valido a nivel request', () {
      final request = CrearClienteRequest(nombres: 'Juan', dni: '1234567');
      expect(request.dni, '1234567');
    });

    test('DNI null es valido (cliente sin DNI)', () {
      final request = CrearClienteRequest(nombres: 'Juan');
      expect(request.dni, isNull);
    });

    test('email y telefono son opcionales', () {
      final request = CrearClienteRequest(nombres: 'Maria');
      expect(request.email, isNull);
      expect(request.telefono, isNull);
    });

    test('crear con todos los campos', () {
      final request = CrearClienteRequest(
        nombres: 'Carlos',
        dni: '87654321',
        email: 'carlos@test.com',
        telefono: '999000111',
      );

      expect(request.nombres, 'Carlos');
      expect(request.dni, '87654321');
      expect(request.email, 'carlos@test.com');
      expect(request.telefono, '999000111');
    });

    test('ActualizarClienteRequest cambia nombres', () {
      final request = ActualizarClienteRequest(idCliente: 1, nombres: 'Nuevo Nombre');
      expect(request.nombres, 'Nuevo Nombre');
      expect(request.idCliente, 1);
    });
  });
}
