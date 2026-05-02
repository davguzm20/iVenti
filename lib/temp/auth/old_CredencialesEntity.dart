import 'package:encrypt/encrypt.dart' as encrypt;

class CredencialesEntity {
  final int? idCredencial;
  final int idUsuario;
  final String tipo;
  final String valor;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  CredencialesEntity({
    this.idCredencial,
    required this.idUsuario,
    required this.tipo,
    required this.valor,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  // Método de encriptación (se mantiene, es utilitario)
  static String encryptPin(String pin, String secretKey) {
    try {
      final key = encrypt.Key.fromUtf8(secretKey.padRight(32).substring(0, 32));
      final iv = encrypt.IV.fromUtf8('16byteslongiv!!!');
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(pin, iv: iv);
      return encrypted.base64;
    } catch (e) {
      return pin; // Si falla, retorna sin encriptar
    }
  }

  // Método de desencriptación (se mantiene, es utilitario)
  static String decryptPin(String encryptedPin, String secretKey) {
    try {
      final key = encrypt.Key.fromUtf8(secretKey.padRight(32).substring(0, 32));
      final iv = encrypt.IV.fromUtf8('16byteslongiv!!!');
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt64(encryptedPin, iv: iv);
      return decrypted;
    } catch (e) {
      return encryptedPin; // Si falla, retorna el original
    }
  }

  CredencialesEntity copyWith({
    int? idCredencial,
    int? idUsuario,
    String? tipo,
    String? valor,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return CredencialesEntity(
      idCredencial: idCredencial ?? this.idCredencial,
      idUsuario: idUsuario ?? this.idUsuario,
      tipo: tipo ?? this.tipo,
      valor: valor ?? this.valor,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_credencial': idCredencial,
      'id_usuario': idUsuario,
      'tipo': tipo,
      'valor': valor,
    };
  }

  factory CredencialesEntity.fromMap(Map<String, dynamic> map) {
    return CredencialesEntity(
      idCredencial: map['id_credencial'] as int?,
      idUsuario: map['id_usuario'] as int,
      tipo: map['tipo'] as String,
      valor: map['valor'] as String,
    );
  }

  @override
  String toString() {
    return 'CredencialesEntity(id: $idCredencial, usuario: $idUsuario, tipo: $tipo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CredencialesEntity &&
        other.idCredencial == idCredencial &&
        other.idUsuario == idUsuario;
  }

  @override
  int get hashCode => idCredencial.hashCode ^ idUsuario.hashCode;
}
