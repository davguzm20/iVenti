import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:provider/provider.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/exceptions/AppException.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/features/auth/widgets/PinInput.dart';

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

  bool _emailCargado = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_emailCargado) _cargarEmail();
  }

  Future<void> _cargarEmail() async {
    _emailCargado = true;

    try {
      final extra = GoRouterState.of(context).extra;

      if (extra is String && extra.isNotEmpty) {
        userEmail = extra;
        return;
      }

      final usuario = await _authController.obtenerUsuarioRegistrado();

      if (mounted) setState(() => userEmail = usuario.email);

    } catch (_) {
      // No hay usuario registrado, se queda en login sin email
    }
  }

  Future<void> _iniciarSesion() async {
    FocusScope.of(context).unfocus();

    if (userPIN.length < 6) {
      _mostrarError('PIN incompleto', 'Ingresa tu PIN de 6 dígitos para continuar.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final usuario = await _authController.iniciarSesion(userEmail, userPIN);
      await ServiceLocator.setUsuarioActual(usuario.idUsuario!);

      if (mounted) context.go('/inventory');

    } on AppException catch (e) {
      if (mounted) {
        ErrorDialog(
          context: context,
          title: e.mensaje,
          description: e.descripcion ?? 'Ocurrió un error inesperado, intenta de nuevo',
        );
      }

    } catch (e) {
      if (mounted) _mostrarError('Error inesperado', e.toString());
    }

    if (mounted) setState(() => isLoading = false);
  }

  void _mostrarError(String titulo, String descripcion) {
    if (mounted) ErrorDialog(context: context, title: titulo, description: descripcion);
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
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                userEmail,
                style: const TextStyle(fontSize: 16, color: AppColors.textLight),
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
                      style: ButtonStyles.success(),
                      onPressed: _iniciarSesion,
                      child: const Text('Ingresar'),
                    ),

              const SizedBox(height: 15),

              TextButton(
                style: ButtonStyles.text(),
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
