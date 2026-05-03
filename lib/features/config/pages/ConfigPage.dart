import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _diasVencimientoController =
      TextEditingController();
  final TextEditingController _stockMinimoController =
      TextEditingController();
  bool isLoading = false;

  ConfiguracionController get _controller =>
      context.read<ConfiguracionController>();

  @override
  void initState() {
    super.initState();

    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => isLoading = true);

    final configs = await _controller.obtenerTodas(1);

    for (final c in configs) {
      if (c.clave == 'dias_vencimiento') {
        _diasVencimientoController.text = c.valor;
      }

      if (c.clave == 'stock_minimo_alerta') {
        _stockMinimoController.text = c.valor;
      }
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _diasVencimientoController.dispose();
    _stockMinimoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Alertas",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF493D9E),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _diasVencimientoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Días antes del vencimiento",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: _stockMinimoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stock mínimo para alerta",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2BBF55),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (_diasVencimientoController.text.isNotEmpty) {
                          await _controller.guardarConfiguracion(
                            CrearConfiguracionRequest(
                              idUsuario: 1,
                              clave: 'dias_vencimiento',
                              valor: _diasVencimientoController.text,
                            ),
                          );
                        }

                        if (_stockMinimoController.text.isNotEmpty) {
                          await _controller.guardarConfiguracion(
                            CrearConfiguracionRequest(
                              idUsuario: 1,
                              clave: 'stock_minimo_alerta',
                              valor: _stockMinimoController.text,
                            ),
                          );
                        }

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Configuraciones guardadas"),
                            ),
                          );
                        }
                      },
                      child: const Text("Guardar configuración"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
