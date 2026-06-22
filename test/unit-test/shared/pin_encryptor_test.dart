import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iventi/shared/utils/PinEncryptor.dart';

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'ENCRYPTION_KEY=YWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWE=\n');
  });

  group('PinEncryptor', () {
    test('mismo PIN + misma key produce mismo hash', () {
      const pin = '123456';
      final h1 = PinEncryptor.hash(pin);
      final h2 = PinEncryptor.hash(pin);

      expect(h1, h2);
    });

    test('el hash tiene 64 caracteres (SHA-256 hex)', () {
      const pin = '123456';
      final hash = PinEncryptor.hash(pin);

      expect(hash.length, 64);
    });

    test('diferentes PINs producen diferente hash', () {
      final h1 = PinEncryptor.hash('123456');
      final h2 = PinEncryptor.hash('654321');

      expect(h1, isNot(h2));
    });

    test('PIN vacio produce hash valido', () {
      final hash = PinEncryptor.hash('');

      expect(hash.length, 64);
    });

    test('PIN con caracteres especiales produce hash valido', () {
      final hash = PinEncryptor.hash('!@#ABC123');

      expect(hash.length, 64);
    });

    test('hash es determinista con la misma ENCRYPTION_KEY', () {
      const pin = '999999';
      final hash = PinEncryptor.hash(pin);

      expect(PinEncryptor.hash(pin), hash);
    });
  });
}
