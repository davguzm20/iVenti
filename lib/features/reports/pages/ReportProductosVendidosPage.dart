import 'package:flutter/material.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteProductosVendidosRequest.dart';

class ReportProductosVendidosPage extends StatefulWidget {
  const ReportProductosVendidosPage({super.key});

  @override
  State<ReportProductosVendidosPage> createState() => _ReportProductosVendidosPageState();
}

class _ReportProductosVendidosPageState extends State<ReportProductosVendidosPage> {
  late final ReportController _controller;
  DateTime inicio = DateTime.now();
  DateTime fin = DateTime.now();
  bool _generando = false;

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator.reportController;
  }

  Future<void> _generar() async {
    setState(() => _generando = true);
    try {
      final request = ReporteProductosVendidosRequest(
        fechaInicio: inicio,
        fechaFinal: fin,
      );
      final data = await _controller.generarProductosVendidos(request);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reporte generado: ${data.length} productos encontrados")),
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
      appBar: AppBar(title: const Text("Productos Vendidos"), backgroundColor: AppColors.background, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rango de fechas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDateField("Inicio", inicio, (d) => setState(() => inicio = d)),
            _buildDateField("Final", fin, (d) => setState(() => fin = d)),
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

  Widget _buildDateField(String label, DateTime date, ValueChanged<DateTime> onChanged) {
    return Row(children: [
      Expanded(child: Text("$label: ${date.toIso8601String().split('T')[0]}")),
      TextButton(
        onPressed: () async {
          final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime.now());
          if (d != null) onChanged(d);
        },
        child: const Text("Seleccionar"),
      ),
    ]);
  }
}
