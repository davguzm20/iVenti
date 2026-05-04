import 'package:flutter/material.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';

class ReportFechaVencimientoPage extends StatefulWidget {
  const ReportFechaVencimientoPage({super.key});

  @override
  State<ReportFechaVencimientoPage> createState() => _ReportFechaVencimientoPageState();
}

class _ReportFechaVencimientoPageState extends State<ReportFechaVencimientoPage> {
  final TextEditingController _diasController = TextEditingController(text: '8');

  @override
  void dispose() { _diasController.dispose(); super.dispose(); }

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
            SizedBox(width: double.infinity, child: ElevatedButton(style: ButtonStyles.success(), onPressed: () {}, child: const Text("Generar"))),
          ],
        ),
      ),
    );
  }
}
