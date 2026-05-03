import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:iventi/shared/exceptions/AppException.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/shared/widgets/PinInput.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';

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

  AuthController get _authController => context.read<AuthController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (email.isEmpty) {
      final extra = GoRouterState.of(context).extra;

      if (extra is String) {
        email = extra;

      } else if (!widget.isRecovery) {
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

    if (pin != confirmPin || pin.length != 6) {
      ErrorDialog(
        context: context,
        errorMessage: 'Los PIN ingresados no coinciden o no tienen 6 dígitos.',
      );
      return;
    }

    if (email.isEmpty) {
      ErrorDialog(
        context: context,
        errorMessage: 'No se encontro el correo del usuario.',
      );
      return;
    }

    if (widget.isRecovery) {
      // Recovery: update PIN directly
      _recuperarPin();
    } else {
      // New user: go to setup page
      GoRouter.of(context).go('/login/setup', extra: {'email': email, 'pin': pin});
    }
  }

  Future<void> _recuperarPin() async {
    try {
      final usuario = await _authController.obtenerUsuarioPorEmail(email);

      await _authController.recuperarPin(usuario.idUsuario!, pin);

      if (mounted) context.go('/login');

    } on AppException catch (e) {
      if (mounted) {
        ErrorDialog(context: context, errorMessage: e.mensaje);
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog(
          context: context,
          errorMessage: 'Error al recuperar PIN: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                      color: Color(0xFF493D9E),
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
                    onPressed: _siguiente,
                    child: const Text(
                      "Siguiente",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
