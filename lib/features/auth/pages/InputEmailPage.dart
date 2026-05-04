import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/shared/services/MailerService.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';
import 'package:iventi/shared/widgets/BackButton.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';

class InputEmailPage extends StatelessWidget {
  const InputEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const InputEmailBody(),
          const BackButtonWidget(),
        ],
      ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    flujo = GoRouterState.of(context).extra as String? ?? 'register';
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _irACodigo(String codigo) {
    context.push('/login/code-email', extra: {
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
        final (title, desc) = DialogMessages.auth.codigoEnviado(emailController.text.trim());
        SuccessDialog(
          context: context,
          title: title,
          description: desc,
          btnOkOnPress: () => _irACodigo(resultado.codigo),
        );
      }
    } else {
      if (mounted) {
        final tieneCredenciales = _mailerService.tieneCredenciales;

        if (tieneCredenciales) {
          ErrorDialog(
            context: context,
            title: 'Error al enviar',
            description: resultado.error!,
          );
        } else {
          ErrorDialog(
            context: context,
            title: 'Modo desarrollo',
            description: resultado.error!,
            btnOkOnPress: () => _irACodigo(resultado.codigo),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/assets/imagenes/logoTienda.png', height: 130),

          const SizedBox(height: 20),

          const Text(
            "Ingrese su correo electrónico",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Ingrese su correo',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
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

          const SizedBox(height: 20),

          isSendEmail
              ? const SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(),
                )
              : ElevatedButton(
                  style: ButtonStyles.success(),
                  onPressed: _enviarCodigo,
                  child: const Text('Confirmar'),
                ),
        ],
      ),
    );
  }
}
