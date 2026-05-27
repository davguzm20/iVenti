import 'package:flutter/material.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:provider/provider.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteLotesRequest.dart';

class ReportLotesPage extends StatefulWidget {
  const ReportLotesPage({super.key});

  @override
  State<ReportLotesPage> createState() => _ReportLotesPageState();
}

class _ReportLotesPageState extends State<ReportLotesPage> {
  late final ReportController _controller;
  DateTime inicio = DateTime.now();
  DateTime fin = DateTime.now();
  String tipo = "General";
  bool _generando = false;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ReportController>();
  }

  Future<void> _generar() async {
    setState(() => _generando = true);
    try {
      final tipoFiltro = tipo == "General" ? null : tipo;
      final request = ReporteLotesRequest(
        fechaInicio: inicio,
        fechaFinal: fin,
        tipo: tipoFiltro,
      );
      final data = await _controller.generarLotes(request);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reporte generado: ${data.length} lotes encontrados")),
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
      appBar: AppBar(title: const Text("Reporte de Lotes"), backgroundColor: AppColors.background, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tipo de lote", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              initialValue: tipo, isExpanded: true,
              items: ["General", "Actuales"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => tipo = v!),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            _buildDate("Inicio", inicio, (d) => inicio = d),
            _buildDate("Final", fin, (d) => fin = d),
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

  Widget _buildDate(String label, DateTime date, ValueChanged<DateTime> onChanged) {
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
