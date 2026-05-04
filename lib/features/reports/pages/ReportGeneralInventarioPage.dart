import 'package:flutter/material.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';

class ReportGeneralInventarioPage extends StatefulWidget {
  const ReportGeneralInventarioPage({super.key});

  @override
  State<ReportGeneralInventarioPage> createState() => _ReportGeneralInventarioPageState();
}

class _ReportGeneralInventarioPageState extends State<ReportGeneralInventarioPage> {
  DateTime fecha = DateTime.now();

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
            SizedBox(width: double.infinity, child: ElevatedButton(style: ButtonStyles.success(), onPressed: () {}, child: const Text("Generar"))),
          ],
        ),
      ),
    );
  }
}
