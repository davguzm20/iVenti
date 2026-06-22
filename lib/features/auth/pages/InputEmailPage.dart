import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/shared/services/MailerService.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
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

    try {
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

          final (title, desc) = DialogMessages.auth.errorEnviarCodigo;
        if (tieneCredenciales) {
            ErrorDialog(context: context, title: title, description: desc);
          } else {
            ErrorDialog(
              context: context,
              title: title,
              description: desc,
              btnOkOnPress: () => _irACodigo(resultado.codigo),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) setState(() => isSendEmail = false);
      if (mounted) {
        final (title, desc) = DialogMessages.auth.errorEnviarCodigo;
        ErrorDialog(context: context, title: title, description: desc);
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
          Image.asset('lib/assets/iconos/iconoApp.png', height: 130),

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
                  return DialogMessages.auth.emailRequerido.$2;
                }
                final emailRegex =
                    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value)) {
                  return DialogMessages.auth.emailInvalido.$2;
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
