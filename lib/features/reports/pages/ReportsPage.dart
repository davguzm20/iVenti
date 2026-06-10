import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/features/reports/widgets/ReportCard.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Reportes", style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ReportCard(
            title: "Reporte Detallado de Ventas",
            icon: Icons.receipt_long,
            onTap: () => context.push('/reports/ventas'),
          ),
          const SizedBox(height: 12),
          ReportCard(
            title: "Productos Vendidos",
            icon: Icons.shopping_cart,
            onTap: () => context.push('/reports/productos-vendidos'),
          ),
          const SizedBox(height: 12),
          ReportCard(
            title: "Inventario General",
            icon: Icons.inventory,
            onTap: () => context.push('/reports/inventario'),
          ),
          const SizedBox(height: 12),
          ReportCard(
            title: "Lotes",
            icon: Icons.ballot,
            onTap: () => context.push('/reports/lotes'),
          ),
          const SizedBox(height: 12),
          ReportCard(
            title: "Próximos a Vencer",
            icon: Icons.calendar_today_outlined,
            onTap: () => context.push('/reports/vencimientos'),
          ),
        ],
      ),
    );
  }
}
