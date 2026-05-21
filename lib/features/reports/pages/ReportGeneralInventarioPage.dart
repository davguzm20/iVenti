import 'package:flutter/material.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteInventarioGeneralRequest.dart';

class ReportGeneralInventarioPage extends StatefulWidget {
  const ReportGeneralInventarioPage({super.key});

  @override
  State<ReportGeneralInventarioPage> createState() => _ReportGeneralInventarioPageState();
}

class _ReportGeneralInventarioPageState extends State<ReportGeneralInventarioPage> {
  late final ReportController _controller;
  DateTime fecha = DateTime.now();
  bool _generando = false;

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator.reportController;
  }

  Future<void> _generar() async {
    setState(() => _generando = true);
    try {
      final request = ReporteInventarioGeneralRequest(fecha: fecha);
      final data = await _controller.generarInventarioGeneral(request);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reporte generado: ${data.length} lotes en inventario")),
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
      appBar: AppBar(title: const Text("Inventario General"), backgroundColor: AppColors.background, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selecciona una fecha", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: Text("Fecha: ${fecha.toIso8601String().split('T')[0]}")),
              TextButton(
                onPressed: () async {
                  final d = await showDatePicker(context: context, initialDate: fecha, firstDate: DateTime(2020), lastDate: DateTime.now());
                  if (d != null) setState(() => fecha = d);
                },
                child: const Text("Seleccionar"),
              ),
            ]),
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
