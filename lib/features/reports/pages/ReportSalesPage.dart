import 'package:flutter/material.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';
import 'package:iventi/features/reports/dtos/requests/ReporteVentasRequest.dart';
import 'package:iventi/features/reports/widgets/DateRangePicker.dart';
import 'package:go_router/go_router.dart';

class ReportSalesPage extends StatefulWidget {
  const ReportSalesPage({super.key});

  @override
  State<ReportSalesPage> createState() => _ReportSalesPageState();
}

class _ReportSalesPageState extends State<ReportSalesPage> {
  late final ReportController _controller;
  DateTime selectedFechaInicio = DateTime.now();
  DateTime selectedFechaFinal = DateTime.now();
  String selectedTipo = "General";
  bool _generando = false;

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator.reportController;
  }

  Future<void> _generar() async {
    setState(() => _generando = true);
    try {
      final tipo = selectedTipo == "General" ? null : selectedTipo;
      final request = ReporteVentasRequest(
        fechaInicio: selectedFechaInicio,
        fechaFinal: selectedFechaFinal,
        tipo: tipo,
      );
      final data = await _controller.generarVentas(request);
      if (!mounted) return;
      if (!context.mounted) return;
      context.push('/report-results', extra: {
        'titulo': 'Reporte Detallado de Ventas',
        'headers': ['#', 'Código Boleta', 'Cliente', 'Fecha', 'Monto Total', 'Pagado', 'Tipo'],
        'data': data.asMap().entries.map((e) => [
          '${e.key + 1}',
          e.value.codigoBoleta,
          e.value.cliente,
          e.value.fecha.toIso8601String().split('T')[0],
          e.value.montoTotal.toStringAsFixed(2),
          e.value.montoCancelado.toStringAsFixed(2),
          e.value.tipo,
        ]).toList(),
      });
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
      appBar: AppBar(title: const Text("Reporte de Ventas"), backgroundColor: AppColors.background, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tipo de reporte", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedTipo,
              items: ["General", "Al contado", "Crédito"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => selectedTipo = v!),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            DateRangePickerWidget(
              startDate: selectedFechaInicio,
              endDate: selectedFechaFinal,
              onStartDateChanged: (d) => setState(() => selectedFechaInicio = d),
              onEndDateChanged: (d) => setState(() => selectedFechaFinal = d),
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


