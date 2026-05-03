import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/shared/services/MailerService.dart';

class InputEmailPage extends StatelessWidget {
  const InputEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const InputEmailBody(),
    );
  }
}

class InputEmailBody extends StatefulWidget {
  const InputEmailBody({super.key});

  @override
  State<InputEmailBody> createState() => _InputEmailBodyState();
}

class _InputEmailBodyState extends State<InputEmailBody> {
  late final TextEditingController emailController;
  late final GlobalKey<FormState> formKey;
  final MailerService _mailerService = MailerService();
  String flujo = 'register';

  bool isSendEmail = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    flujo = GoRouterState.of(context).extra as String? ?? 'register';
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _irACodigo(String codigo) {
    context.go('/login/code-email', extra: {
      'codigo': codigo,
      'email': emailController.text.trim(),
      'flujo': flujo,
    });
  }

  Future<void> _enviarCodigo() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    setState(() => isSendEmail = true);

    final resultado = await _mailerService.enviarCodigo(
      emailController.text.trim(),
    );

    if (mounted) setState(() => isSendEmail = false);

    if (resultado.enviado) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: "Correcto",
          desc:
              "El código se ha enviado a su correo ${emailController.text} correctamente!",
          btnOkOnPress: () => _irACodigo(resultado.codigo),
          btnOkIcon: Icons.check_circle,
          btnOkColor: Colors.green,
        ).show();
      }

      } else {
      if (mounted) {
        final tieneCredenciales = _mailerService.tieneCredenciales;

        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: tieneCredenciales ? "Error" : "Configuración",
          desc: resultado.error!,
          btnOkOnPress: tieneCredenciales
              ? () {}
              : () => _irACodigo(resultado.codigo),
          btnOkIcon: Icons.cancel,
          btnOkColor: tieneCredenciales ? Colors.red : Colors.orange,
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(64, 34, 197, 1);
    const borderColor = Color.fromRGBO(98, 72, 190, 0.4);

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/assets/imagenes/logoTienda.png', height: 200),

          const SizedBox(height: 50),

          const Text(
            "Ingrese su correo electrónico",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(30, 60, 87, 1),
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Ingrese su correo',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: focusedBorderColor),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese su correo';
                }
                final emailRegex =
                    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Ingrese un correo válido';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 30),

          isSendEmail
              ? const SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(),
                )
              : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.greenAccent;
                      }
                      return Colors.green;
                    }),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 35),
                    ),
                  ),
                  onPressed: _enviarCodigo,
                  child: const Text('Confirmar'),
                ),
        ],
      ),
    );
  }
}
