import 'package:flutter/material.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';

class ReportProductosVendidosPage extends StatefulWidget {
  const ReportProductosVendidosPage({super.key});

  @override
  State<ReportProductosVendidosPage> createState() => _ReportProductosVendidosPageState();
}

class _ReportProductosVendidosPageState extends State<ReportProductosVendidosPage> {
  DateTime inicio = DateTime.now();
  DateTime fin = DateTime.now();

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
            SizedBox(width: double.infinity, child: ElevatedButton(style: ButtonStyles.success(), onPressed: () {}, child: const Text("Generar"))),
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
