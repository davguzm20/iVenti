import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/exceptions/AppException.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
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

  AuthController get _authController => ServiceLocator.authController;

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

      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('last_logged_in_email');
      if (savedEmail != null && savedEmail.isNotEmpty) {
        if (mounted) setState(() => userEmail = savedEmail);
        return;
      }

      final usuario = await _authController.obtenerUsuarioRegistrado();

      if (mounted) setState(() => userEmail = usuario.email);

    } catch (_) {}
  }

  Future<void> _iniciarSesion() async {
    FocusScope.of(context).unfocus();

    if (userPIN.length < 6) {
      final (title, desc) = DialogMessages.auth.pinIncompleto;
      _mostrarError(title, desc);
      return;
    }

    setState(() => isLoading = true);

    try {
      final usuario = await _authController.iniciarSesion(userEmail, userPIN);
      await ServiceLocator.setUsuarioActual(usuario.idUsuario!);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('device_registered', true);
      await prefs.setString('last_logged_in_email', userEmail);

      if (mounted) context.go('/inventory');

    } on AppException catch (e) {
      if (mounted) {
        final (title, description) = _tituloError(e);
        final errorCrudo = 'Tipo: ${e.runtimeType}\nCódigo: ${e.codigo}\nMensaje: ${e.mensaje}${e.descripcion != null ? '\nDetalle: ${e.descripcion}' : ''}';
        ErrorDialog(context: context, title: title, description: '$description\n\n$errorCrudo');
      }

    } catch (e) {
      if (mounted) {
        ErrorDialog(
          context: context,
          title: 'Error inesperado',
          description: 'Tipo: ${e.runtimeType}\n${e.toString()}',
        );
      }
    }

    if (mounted) setState(() => isLoading = false);
  }

  void _mostrarError(String titulo, String descripcion) {
    if (mounted) ErrorDialog(context: context, title: titulo, description: descripcion);
  }

  (String, String) _tituloError(AppException e) {
    switch (e.codigo) {
      case 'VALIDATION_ERROR':
        return DialogMessages.error.validacion(e.mensaje);
      case 'AUTH_ERROR':
        return DialogMessages.error.autenticacion(e.mensaje);
      case 'DATABASE_ERROR':
        return DialogMessages.error.conexion(e.mensaje);
      case 'NOT_FOUND':
        return DialogMessages.error.noEncontrado(e.mensaje);
      default:
        return (e.mensaje, e.descripcion ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  Image.asset('lib/assets/iconos/iconoApp.png', height: 150),

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
                    obscureText: true,
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

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28),
                  color: Colors.black87,
                  onPressed: () => context.go('/welcome'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
