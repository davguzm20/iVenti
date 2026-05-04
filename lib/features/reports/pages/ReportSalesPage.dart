import 'package:flutter/material.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';

class ReportSalesPage extends StatefulWidget {
  const ReportSalesPage({super.key});

  @override
  State<ReportSalesPage> createState() => _ReportSalesPageState();
}

class _ReportSalesPageState extends State<ReportSalesPage> {
  DateTime selectedFechaInicio = DateTime.now();
  DateTime selectedFechaFinal = DateTime.now();
  String selectedTipo = "General";

  Future<void> _seleccionarFecha(bool inicio) async {
    final d = await showDatePicker(
      context: context,
      initialDate: inicio ? selectedFechaInicio : selectedFechaFinal,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() { if (inicio) selectedFechaInicio = d; else selectedFechaFinal = d; });
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
              value: selectedTipo,
              items: ["General", "Al contado", "Crédito"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => selectedTipo = v!),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: Text("Inicio: ${selectedFechaInicio.toIso8601String().split('T')[0]}")),
              TextButton(onPressed: () => _seleccionarFecha(true), child: const Text("Seleccionar")),
            ]),
            Row(children: [
              Expanded(child: Text("Final: ${selectedFechaFinal.toIso8601String().split('T')[0]}")),
              TextButton(onPressed: () => _seleccionarFecha(false), child: const Text("Seleccionar")),
            ]),
            const Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ButtonStyles.success(), onPressed: () {}, child: const Text("Generar"))),
          ],
        ),
      ),
    );
  }
}
