import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/shared/exceptions/AppException.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/widgets/BackButton.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';

import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';

class SetupConfigPage extends StatefulWidget {
  final String email;
  final String pin;
  final AuthController authController;
  final ConfiguracionController configController;

  const SetupConfigPage({
    super.key,
    required this.email,
    required this.pin,
    required this.authController,
    required this.configController,
  });

  @override
  State<SetupConfigPage> createState() => _SetupConfigPageState();
}

class _SetupConfigPageState extends State<SetupConfigPage> {
  late final TextEditingController nombreController;
  late final TextEditingController diasVencimientoController;
  late final TextEditingController stockMinimoController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController();
    diasVencimientoController = TextEditingController(text: '8');
    stockMinimoController = TextEditingController(text: '5');
  }

  @override
  void dispose() {
    nombreController.dispose();
    diasVencimientoController.dispose();
    stockMinimoController.dispose();
    super.dispose();
  }

  Future<void> _completarSetup() async {
    FocusScope.of(context).unfocus();

    if (nombreController.text.trim().isEmpty) {
      final (title, desc) = DialogMessages.auth.nombreRequerido;
      ErrorDialog(context: context, title: title, description: desc);
      return;
    }

    if (diasVencimientoController.text.trim().isEmpty) {
      final (title, desc) = DialogMessages.auth.diasVencimientoRequerido;
      ErrorDialog(context: context, title: title, description: desc);
      return;
    }

    if (stockMinimoController.text.trim().isEmpty) {
      final (title, desc) = DialogMessages.auth.stockMinimoRequerido;
      ErrorDialog(context: context, title: title, description: desc);
      return;
    }

    setState(() => isLoading = true);

    try {
      final usuario = await widget.authController.registrar(
        CrearUsuarioRequest(
          nombre: nombreController.text.trim(),
          email: widget.email,
          pin: widget.pin,
        ),
      );

      if (diasVencimientoController.text.isNotEmpty) {
        await widget.configController.guardarConfiguracion(
          CrearConfiguracionRequest(
            idUsuario: usuario.idUsuario!,
            clave: 'dias_vencimiento',
            valor: diasVencimientoController.text.trim(),
          ),
        );
      }

      if (stockMinimoController.text.isNotEmpty) {
        await widget.configController.guardarConfiguracion(
          CrearConfiguracionRequest(
            idUsuario: usuario.idUsuario!,
            clave: 'stock_minimo_alerta',
            valor: stockMinimoController.text.trim(),
          ),
        );
      }

      if (mounted) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;

        final (title, desc) = DialogMessages.auth.configuracionCompletada;
        SuccessDialog(
          context: context,
          title: title,
          description: desc,
          btnOkOnPress: () => context.go('/login', extra: timestamp),
        );
      }

    } on AppException catch (e) {
      if (mounted) {
        ErrorDialog(
          context: context,
          title: e.mensaje,
          description: e.descripcion ?? 'No pudimos completar la configuración, verifica tus datos e intenta de nuevo',
        );
      }

    } catch (e) {
      if (mounted) {
        ErrorDialog(
          context: context,
          title: 'Error inesperado',
          description: 'Ocurrió un error al guardar la configuración, intenta de nuevo',
        );
      }
    }

    if (mounted) setState(() => isLoading = false);
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

              Image.asset(
                'lib/assets/imagenes/logoTienda.png',
                height: 150,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              const Text(
                'Completa tu configuración',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del usuario *',
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: diasVencimientoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Días antes del vencimiento *',
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: stockMinimoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock mínimo para alerta *',
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ButtonStyles.success(),
                      onPressed: _completarSetup,
                      child: const Text('Finalizar'),
                    ),

              const SizedBox(height: 50),
            ],
          ),
        ),
        ),
        BackButtonWidget(),
        ],
      ),
    );
  }
}
