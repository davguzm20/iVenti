import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/features/auth/widgets/PinInput.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/LoadingDialog.dart';
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
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  Future<void> validateCode() async {
    if (_isProcessing) return;
    _isProcessing = true;
    FocusScope.of(context).unfocus();
    LoadingDialog.show(context);

    try {
      if (inputCode == widget.correctCode) {
        if (widget.flujo == 'verify') {
          try {
            final authController = context.read<AuthController>();
            await authController.obtenerUsuarioPorEmail(widget.emailUser);
          } catch (e) {
            debugPrint('Error al verificar usuario por email: $e');
            final (titulo, desc) = DialogMessages.auth.cuentaNoEncontrada;
            if (!mounted) return;
            ErrorDialog(
              context: context,
              title: titulo,
              description: desc,
              btnOkOnPress: () => context.push('/login/create-pin', extra: widget.emailUser),
            );
            return;
          }
        }

        if (!mounted) return;
        if (mounted) LoadingDialog.hide(context);
        _isProcessing = false;
        final (_, descOk) = DialogMessages.auth.codigoEnviado(widget.emailUser);
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: "Correcto",
          desc: descOk,
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
        if (mounted) LoadingDialog.hide(context);
        _isProcessing = false;
        final (titleErr, descErr) = DialogMessages.auth.codigoIncorrecto;
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: titleErr,
          desc: descErr,
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red,
        ).show();
      }
    } catch (e) {
      if (mounted) LoadingDialog.hide(context);
      _isProcessing = false;
      debugPrint('Error en validateCode: $e');
      if (mounted) {
        final (title, desc) = DialogMessages.auth.errorValidarCodigo;
        ErrorDialog(context: context, title: title, description: desc);
      }
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
                    'lib/assets/iconos/iconoApp.png',
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
