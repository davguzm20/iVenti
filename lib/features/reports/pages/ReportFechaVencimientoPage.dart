import 'package:flutter/material.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:provider/provider.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProximosVencerRequest.dart';

class ReportFechaVencimientoPage extends StatefulWidget {
  const ReportFechaVencimientoPage({super.key});

  @override
  State<ReportFechaVencimientoPage> createState() => _ReportFechaVencimientoPageState();
}

class _ReportFechaVencimientoPageState extends State<ReportFechaVencimientoPage> {
  late final ReportController _controller;
  final TextEditingController _diasController = TextEditingController(text: '8');
  bool _generando = false;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ReportController>();
  }

  @override
  void dispose() { _diasController.dispose(); super.dispose(); }

  Future<void> _generar() async {
    final dias = int.tryParse(_diasController.text);
    if (dias == null || dias <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingrese un número válido de días"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _generando = true);
    try {
      final request = ReporteProximosVencerRequest(dias: dias);
      final data = await _controller.generarProximosVencer(request);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reporte generado: ${data.length} lotes próximos a vencer")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _generando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Próximos a Vencer"), backgroundColor: AppColors.background, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Días antes del vencimiento", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _diasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Días", border: OutlineInputBorder()),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyles.success(),
                onPressed: _generando ? null : _generar,
                child: _generando
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Generar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
