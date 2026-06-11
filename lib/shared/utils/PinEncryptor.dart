import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PinEncryptor {
  static String hash(String pin) {
    final key = utf8.encode(dotenv.env['ENCRYPTION_KEY']!);
    final hmac = Hmac(sha256, key);
    final bytes = utf8.encode(pin);
    return hmac.convert(bytes).toString();
  }
}
