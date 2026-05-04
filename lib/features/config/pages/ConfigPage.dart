import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';
import 'package:iventi/shared/widgets/BackButton.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _diasVencimientoController =
      TextEditingController();
  final TextEditingController _stockMinimoController =
      TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => isLoading = true);

    try {
      final usuario = await ServiceLocator.authController.obtenerUsuarioRegistrado();
      _nombreController.text = usuario.nombre;

      final configs = await ServiceLocator.configuracionController.obtenerTodas(
        usuario.idUsuario!,
      );

      for (final c in configs) {
        if (c.clave == 'dias_vencimiento') {
          _diasVencimientoController.text = c.valor;
        }
        if (c.clave == 'stock_minimo_alerta') {
          _stockMinimoController.text = c.valor;
        }
      }
    } catch (_) {}

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _guardar() async {
    final idUsuario = ServiceLocator.usuarioActualId ?? 1;

    if (_nombreController.text.trim().isNotEmpty) {
      await ServiceLocator.authController.actualizarPerfil(
        idUsuario,
        nombre: _nombreController.text.trim(),
      );
    }

    if (_diasVencimientoController.text.isNotEmpty) {
      await ServiceLocator.configuracionController.guardarConfiguracion(
        CrearConfiguracionRequest(
          idUsuario: idUsuario,
          clave: 'dias_vencimiento',
          valor: _diasVencimientoController.text,
        ),
      );
    }

    if (_stockMinimoController.text.isNotEmpty) {
      await ServiceLocator.configuracionController.guardarConfiguracion(
        CrearConfiguracionRequest(
          idUsuario: idUsuario,
          clave: 'stock_minimo_alerta',
          valor: _stockMinimoController.text,
        ),
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Configuración guardada")),
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
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),

                        const Text(
                          'Configuración',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),

                        const SizedBox(height: 30),

                        TextField(
                          controller: _nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del usuario *',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: _diasVencimientoController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Días antes del vencimiento *',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: _stockMinimoController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Stock mínimo para alerta *',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyles.success(),
                            onPressed: _guardar,
                            child: const Text('Guardar configuración'),
                          ),
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
