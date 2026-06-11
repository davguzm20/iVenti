import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/exceptions/AppException.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/shared/widgets/ConfirmDialog.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _diasVencimientoController = TextEditingController();
  final TextEditingController _stockMinimoController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => isLoading = true);
    final authCtrl = ServiceLocator.authController;
    final configCtrl = ServiceLocator.configuracionController;
    try {
      final usuario = await authCtrl.obtenerUsuarioRegistrado();
      _nombreController.text = usuario.nombre;
      final configs = await configCtrl.obtenerTodas(usuario.idUsuario!);
      for (final c in configs) {
        if (c.clave == 'dias_vencimiento') _diasVencimientoController.text = c.valor;
        if (c.clave == 'stock_minimo_alerta') _stockMinimoController.text = c.valor;
      }
    } catch (e) {
      debugPrint('Error al cargar configuracion: $e');
    }
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _guardar() async {
    if (_nombreController.text.trim().isEmpty) {
      final (title, desc) = DialogMessages.auth.nombreRequerido;
      if (mounted) ErrorDialog(context: context, title: title, description: desc);
      return;
    }

    final diasText = _diasVencimientoController.text.trim();
    if (diasText.isEmpty) {
      final (title, desc) = DialogMessages.auth.diasVencimientoRequerido;
      if (mounted) ErrorDialog(context: context, title: title, description: desc);
      return;
    }
    final diasValor = int.tryParse(diasText);
    if (diasValor == null || diasValor <= 0) {
      final (title, desc) = DialogMessages.auth.diasVencimientoInvalido;
      if (mounted) ErrorDialog(context: context, title: title, description: desc);
      return;
    }

    final stockText = _stockMinimoController.text.trim();
    if (stockText.isEmpty) {
      final (title, desc) = DialogMessages.auth.stockMinimoRequerido;
      if (mounted) ErrorDialog(context: context, title: title, description: desc);
      return;
    }
    final stockValor = int.tryParse(stockText);
    if (stockValor == null || stockValor <= 0) {
      final (title, desc) = DialogMessages.auth.stockMinimoInvalido;
      if (mounted) ErrorDialog(context: context, title: title, description: desc);
      return;
    }

    if (mounted) {
      ConfirmDialog(
        context: context,
        title: 'Guardar configuración',
        message: '¿Estás seguro de guardar los cambios?',
        btnOkOnPress: () async {
          final authCtrl = ServiceLocator.authController;
          final configCtrl = ServiceLocator.configuracionController;
          final idUsuario = ServiceLocator.usuarioActualId ?? 1;
          try {
            await authCtrl.actualizarPerfil(idUsuario, nombre: _nombreController.text.trim());
            await configCtrl.guardarConfiguracion(
              CrearConfiguracionRequest(idUsuario: idUsuario, clave: 'dias_vencimiento', valor: diasText),
            );
            await configCtrl.guardarConfiguracion(
              CrearConfiguracionRequest(idUsuario: idUsuario, clave: 'stock_minimo_alerta', valor: stockText),
            );
            if (mounted) {
              SuccessDialog(
                context: context,
                title: 'Configuración guardada',
                description: 'Los cambios se guardaron correctamente.',
                btnOkOnPress: () {},
              );
            }
          } on AppException catch (e) {
            if (mounted) {
              ErrorDialog(
                context: context,
                title: e.mensaje,
                description: e.descripcion ?? 'No pudimos guardar la configuración, intenta de nuevo',
              );
            }
          } catch (e) {
            debugPrint('Error al guardar configuracion: $e');
            if (mounted) {
              ErrorDialog(
                context: context,
                title: 'Error inesperado',
                description: e.toString(),
              );
            }
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _diasVencimientoController.dispose();
    _stockMinimoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración", style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined, color: Colors.black),
            onPressed: () => context.push('/config/notifications'),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 10),
                  TextField(controller: _nombreController, decoration: const InputDecoration(labelText: 'Nombre del usuario *', border: OutlineInputBorder())),
                  const SizedBox(height: 30),
                  const Text('Alertas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 10),
                  TextField(controller: _diasVencimientoController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Días antes del vencimiento *', border: OutlineInputBorder())),
                  const SizedBox(height: 15),
                  TextField(controller: _stockMinimoController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock mínimo para alerta *', border: OutlineInputBorder())),
                  const SizedBox(height: 40),
                  SizedBox(width: double.infinity, child: ElevatedButton(style: ButtonStyles.success(), onPressed: _guardar, child: const Text('Guardar configuración'))),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}

