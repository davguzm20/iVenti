import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/widgets/PinInput.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/BackButton.dart';

class CodeEmailPage extends StatefulWidget {
  final String correctCode;
  final String emailUser;
  final String flujo;

  const CodeEmailPage({
    super.key,
    required this.correctCode,
    required this.emailUser,
    required this.flujo,
  });

  @override
  State<CodeEmailPage> createState() => _CodeEmailPageState();
}

class _CodeEmailPageState extends State<CodeEmailPage> {
  String inputCode = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  Future<void> validateCode() async {
    FocusScope.of(context).unfocus();

    if (inputCode == widget.correctCode) {
      if (widget.flujo == 'verify') {
        final authController = ServiceLocator.authController;

        try {
          await authController.obtenerUsuarioPorEmail(widget.emailUser);
        } catch (_) {
          final (titulo, desc) = DialogMessages.auth.cuentaNoEncontrada;
        ErrorDialog(
            context: context,
            title: titulo,
            description: desc,
            btnOkOnPress: () => context.push('/login/create-pin', extra: widget.emailUser),
          );
          return;
        }
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: "Correcto",
        desc: "¡El código es correcto!",
        btnOkOnPress: () {
          if (widget.flujo == 'verify') {
            context.go('/login', extra: widget.emailUser);
          } else {
            context.push('/login/create-pin', extra: widget.emailUser);
          }
        },
        btnOkIcon: Icons.check_circle,
        btnOkColor: Colors.green,
      ).show();

    } else {
      AwesomeDialog(
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
      body: Stack(
        children: [
          Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/imagenes/logoTienda.png',
                    height: 150,
                    width: 150,
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Ingresa el código que enviamos a tu correo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
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
                    style: ButtonStyles.success(),
                    onPressed: validateCode,
                    child: const Text("Confirmar"),
                  ),
                ],
              ),
            ),
          ),
          ),
          ),
          BackButtonWidget(),
        ],
      ),
    );
  }
}
