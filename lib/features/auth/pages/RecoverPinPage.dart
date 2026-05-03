import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/shared/services/MailerService.dart';
import 'package:iventi/shared/widgets/PinInput.dart';

class RecoverPinPage extends StatefulWidget {
  const RecoverPinPage({super.key});

  @override
  State<RecoverPinPage> createState() => _RecoverPinPageState();
}

class _RecoverPinPageState extends State<RecoverPinPage> {
  final MailerService _mailerService = MailerService();
  String inputCode = "";
  String codigo = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (mounted) _enviarCodigoEmail();
    });
  }

  Future<void> _enviarCodigoEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C10BB)),
              strokeWidth: 3.5,
            ),
            SizedBox(height: 20),
            Text("Enviando código...",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3C57))),
            SizedBox(height: 5),
            Text("Por favor, espere un momento",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );

    final resultado = await _mailerService.enviarCodigo("");

    if (mounted) Navigator.pop(context);

    if (resultado.enviado || !_mailerService.tieneCredenciales) {
      codigo = resultado.codigo;
    }

    if (mounted) {
      final credencialesOk = _mailerService.tieneCredenciales;

      AwesomeDialog(
        context: context,
        dialogType: credencialesOk ? DialogType.success : DialogType.error,
        animType: AnimType.topSlide,
        title: credencialesOk ? "Correcto" : "Aviso",
        desc: resultado.error ?? "Código enviado correctamente!",
        btnOkOnPress: () => FocusScope.of(context).requestFocus(FocusNode()),
        btnOkIcon:
            credencialesOk ? Icons.check_circle : Icons.warning_amber,
        btnOkColor: credencialesOk ? Colors.green : Colors.orange,
      ).show();
    }
  }

  Future<void> _validateCode() async {
    FocusScope.of(context).unfocus();

    if (inputCode == codigo) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: "Correcto",
        desc: "¡El código es correcto!",
        btnOkOnPress: () => context.go('/login/create-pin', extra: true),
        btnOkIcon: Icons.check_circle,
        btnOkColor: Colors.green,
      ).show();

    } else {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: "Error",
        desc: "El código ingresado es incorrecto. Inténtalo nuevamente.",
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Confirmar Código",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(30, 60, 87, 1),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/imagenes/logoTienda.png',
                      height: 150, width: 150),

                  const SizedBox(height: 30),

                  const Text(
                    "Se le ha enviado un código a su correo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(30, 60, 87, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: 280,
                    child: PinInput(
                      length: 6,
                      onChanged: (value) => inputCode = value,
                    ),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 35,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _validateCode,
                    child: const Text(
                      "Confirmar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
