import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:go_router/go_router.dart';

import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/exceptions/AppException.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/shared/widgets/BackButton.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/features/auth/widgets/PinInput.dart';

class CreatePinPage extends StatefulWidget {
  final bool isRecovery;

  const CreatePinPage({super.key, required this.isRecovery});

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  String pin = "";
  String confirmPin = "";
  String email = "";

  AuthController get _authController => ServiceLocator.authController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (email.isEmpty) {
      final extra = GoRouterState.of(context).extra;

      if (extra is String) {
        email = extra;

      } else {
        _obtenerEmail();
      }
    }
  }

  Future<void> _obtenerEmail() async {
    try {
      final usuario = await _authController.obtenerUsuarioRegistrado();

      if (mounted) {
        setState(() => email = usuario.email);
      }

    } catch (_) {}
  }

  void _siguiente() {
    FocusScope.of(context).unfocus();

    if (pin.length != 6) {
      final (title, desc) = DialogMessages.auth.pinInvalido;
      ErrorDialog(
        context: context,
        title: title,
        description: desc,
      );
      return;
    }

    if (pin != confirmPin) {
      final (title, desc) = DialogMessages.auth.pinNoCoincide;
      ErrorDialog(
        context: context,
        title: title,
        description: desc,
      );
      return;
    }

    if (email.isEmpty) {
      final (titulo, desc) = DialogMessages.auth.correoNoDisponible;
      ErrorDialog(context: context, title: titulo, description: desc);
      return;
    }

    if (widget.isRecovery) {
      // Recuperación: actualizar PIN directamente
      _recuperarPin();
    } else {
      // Usuario nuevo: ir a página de configuración
      context.push('/login/setup', extra: {'email': email, 'pin': pin});
    }
  }

  Future<void> _recuperarPin() async {
    try {
      final usuario = await _authController.obtenerUsuarioPorEmail(email);

      await _authController.recuperarPin(usuario.idUsuario!, pin);

      if (mounted) context.go('/login');

    } on AppException catch (e) {
      if (mounted) {
        ErrorDialog(
          context: context,
          title: e.mensaje,
          description: e.descripcion ?? 'No pudimos recuperar tu PIN, intenta de nuevo',
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog(
          context: context,
          title: 'Error inesperado',
          description: 'Ocurrió un error inesperado, intenta de nuevo',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      'lib/assets/imagenes/logoTienda.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Registrando: $email",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Crea un PIN de 6 dígitos para asegurar tu cuenta",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  PinInput(
                    length: 6,
                    obscureText: true,
                    onChanged: (value) => pin = value,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Vuelve a ingresar el PIN para confirmar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  PinInput(
                    length: 6,
                    obscureText: true,
                    onChanged: (value) => confirmPin = value,
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ButtonStyles.success(),
                    onPressed: _siguiente,
                    child: const Text("Siguiente"),
                  ),

                  const SizedBox(height: 30),
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
