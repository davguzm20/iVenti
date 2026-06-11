import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';

void main() {
  group('CrearClienteRequest', () {
    test('nombres es obligatorio', () {
      final request = CrearClienteRequest(nombres: 'Juan');
      expect(request.nombres, 'Juan');
    });

    test('dni opcional sin valor', () {
      final request = CrearClienteRequest(nombres: 'Maria');
      expect(request.dni, isNull);
    });

    test('con email y telefono opcionales', () {
      final request = CrearClienteRequest(
        nombres: 'Pedro',
        dni: '11111111',
        email: 'pedro@test.com',
        telefono: '999888777',
      );

      expect(request.nombres, 'Pedro');
      expect(request.dni, '11111111');
      expect(request.email, 'pedro@test.com');
      expect(request.telefono, '999888777');
    });
  });
}
