import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iventi/shared/utils/DniEncryptor.dart';

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'ENCRYPTION_KEY=YWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWE=\n');
  });

  group('DniEncryptor', () {
    test('encryptAES y decryptAES: ciclo completo', () {
      const dni = '12345678';
      final encrypted = DniEncryptor.encryptAES(dni);

      expect(encrypted, isNot(dni));
      expect(encrypted, contains(':'));
      expect(encrypted.split(':').length, 2);

      final decrypted = DniEncryptor.decryptAES(encrypted);
      expect(decrypted, dni);
    });

    test('encryptAES produce distinto ciphertext para mismo input (IV aleatorio)', () {
      const dni = '87654321';
      final e1 = DniEncryptor.encryptAES(dni);
      final e2 = DniEncryptor.encryptAES(dni);

      expect(e1, isNot(e2));
      expect(DniEncryptor.decryptAES(e1), dni);
      expect(DniEncryptor.decryptAES(e2), dni);
    });

    test('decryptAES retorna plaintext legacy sin cambios', () {
      const legacyDni = '99999999';
      final result = DniEncryptor.decryptAES(legacyDni);

      expect(result, legacyDni);
    });

    test('encryptAES con DNI de 8 digitos', () {
      const dni = '12345678';
      final encrypted = DniEncryptor.encryptAES(dni);

      expect(DniEncryptor.decryptAES(encrypted), dni);
    });

    test('encryptAES con DNI que contiene letras', () {
      const dni = 'ABC12345';
      final encrypted = DniEncryptor.encryptAES(dni);

      expect(DniEncryptor.decryptAES(encrypted), dni);
    });

    test('encryptAES con string vacio lanza RangeError', () {
      expect(
        () => DniEncryptor.encryptAES(''),
        throwsA(isA<RangeError>()),
      );
    });

    test('decryptAES con formato invalido (sin dos puntos) retorna tal cual', () {
      const invalid = 'sin_formato_correcto';
      final result = DniEncryptor.decryptAES(invalid);

      expect(result, invalid);
    });
  });
}
