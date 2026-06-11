import 'dart:convert';
import 'package:crypto/crypto.dart';

class PinEncryptor {
  static String hash(String pin) {
    final bytes = utf8.encode(pin);
    return sha256.convert(bytes).toString();
  }
}
