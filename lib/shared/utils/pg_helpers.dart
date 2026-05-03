import 'dart:convert';

String pgString(dynamic value) {
  if (value is String) return value;
  if (value is List<int>) return utf8.decode(value);
  try {
    final bytes = (value as dynamic).bytes as List<int>;
    return utf8.decode(bytes);
  } catch (_) {
    return value.toString();
  }
}
