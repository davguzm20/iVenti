import 'package:encrypt/encrypt.dart' as aes;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DniEncryptor {
  static aes.Key get _key {
    final keyB64 = dotenv.env['ENCRYPTION_KEY']!;
    return aes.Key.fromBase64(keyB64);
  }

  static String encryptAES(String plaintext) {
    final iv = aes.IV.fromSecureRandom(16);
    final encrypter = aes.Encrypter(aes.AES(_key));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static String decryptAES(String data) {
    if (!data.contains(':')) return data;
    final parts = data.split(':');
    final iv = aes.IV.fromBase64(parts[0]);
    final encrypter = aes.Encrypter(aes.AES(_key));
    return encrypter.decrypt64(parts[1], iv: iv);
  }
}
