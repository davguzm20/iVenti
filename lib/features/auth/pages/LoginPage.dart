import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/shared/exceptions/AppException.dart';
import 'package:iventi/shared/widgets/PinInput.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userEmail = '';
  String userPIN = '';
  bool isLoading = false;

  AuthController get _authController => context.read<AuthController>();

  @override
  void initState() {
    super.initState();
    _cargarEmail();
  }

  Future<void> _cargarEmail() async {
    try {
      final extra = GoRouterState.of(context).extra;

      if (extra is String && extra.isNotEmpty) {
        userEmail = extra;
        return;
      }

      final usuario = await _authController.obtenerUsuarioRegistrado();

      if (mounted) setState(() => userEmail = usuario.email);

    } catch (_) {
      if (mounted) context.go('/welcome');
    }
  }

  Future<void> _iniciarSesion() async {
    FocusScope.of(context).unfocus();

    if (userPIN.length < 6) {
      ErrorDialog(context: context, errorMessage: 'Ingrese su PIN de 6 dígitos');
      return;
    }

    setState(() => isLoading = true);

    try {
      await _authController.iniciarSesion(userEmail, userPIN);

      if (mounted) context.go('/inventory');

    } on AppException catch (e) {
      if (mounted) {
        ErrorDialog(context: context, errorMessage: e.mensaje);
      }

    } catch (e) {
      if (mounted) {
        ErrorDialog(context: context, errorMessage: 'Error al iniciar sesión');
      }
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              Image.asset('lib/assets/imagenes/logoTienda.png', height: 150),

              const SizedBox(height: 30),

              const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(30, 60, 87, 1),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                userEmail,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              PinInput(
                length: 6,
                onChanged: (value) => userPIN = value,
                onCompleted: (value) => userPIN = value,
              ),

              const SizedBox(height: 30),

              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.green, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 35,
                        ),
                      ),
                      onPressed: _iniciarSesion,
                      child: const Text('Ingresar'),
                    ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () => context.go('/login/recover-pin', extra: userEmail),
                child: const Text('¿Olvidaste tu PIN?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
