import 'package:flutter/material.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';

class ReportLotesPage extends StatefulWidget {
  const ReportLotesPage({super.key});

  @override
  State<ReportLotesPage> createState() => _ReportLotesPageState();
}

class _ReportLotesPageState extends State<ReportLotesPage> {
  DateTime inicio = DateTime.now();
  DateTime fin = DateTime.now();
  String tipo = "General";

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
              value: tipo, isExpanded: true,
              items: ["General", "Actuales"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => tipo = v!),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            _buildDate("Inicio", inicio, (d) => inicio = d),
            _buildDate("Final", fin, (d) => fin = d),
            const Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ButtonStyles.success(), onPressed: () {}, child: const Text("Generar"))),
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
}
