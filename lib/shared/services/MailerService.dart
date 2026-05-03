import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/mailer.dart';

class MailerResult {
  final bool enviado;
  final String codigo;
  final String? error;

  MailerResult({required this.enviado, required this.codigo, this.error});
}

class MailerService {
  String _addressSendEmail = '';
  String _passwordSendEmail = '';

  MailerService() {
    _addressSendEmail = dotenv.env['SMTP_EMAIL'] ?? '';
    _passwordSendEmail = dotenv.env['SMTP_PASSWORD'] ?? '';
  }

  bool get tieneCredenciales =>
      _addressSendEmail.isNotEmpty && _passwordSendEmail.isNotEmpty;

  String generarCodigoVerificacion() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  Future<MailerResult> enviarCodigo(String destinatario) async {
    final codigo = generarCodigoVerificacion();

    if (!tieneCredenciales) {
      return MailerResult(
        enviado: false,
        codigo: codigo,
        error:
            'No hay credenciales SMTP configuradas. Tu código es: $codigo',
      );
    }

    try {
      final smtpServer = gmail(_addressSendEmail, _passwordSendEmail);
      final message = Message()
        ..from = Address(_addressSendEmail)
        ..recipients.add(destinatario)
        ..subject = 'Código de verificación'
        ..text = 'Tu código de verificación es: $codigo';

      await send(message, smtpServer);

      return MailerResult(
        enviado: true,
        codigo: codigo,
        error: null,
      );

    } on MailerException catch (e) {
      return MailerResult(
        enviado: false,
        codigo: codigo,
        error: 'Error al enviar el código: $e',
      );
    }
  }
}
