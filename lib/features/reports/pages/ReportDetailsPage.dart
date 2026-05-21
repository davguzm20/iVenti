import 'package:flutter/material.dart';
import 'package:iventi/shared/theme/AppColors.dart';

class ReportDetailsPage extends StatelessWidget {
  const ReportDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportes", style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(child: Text("Selecciona un reporte")),
    );
  }
}
