import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';

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
          _buildReportCard(context, "Reporte Detallado de Ventas", Icons.receipt_long, () => context.push('/reports/ventas')),
          const SizedBox(height: 12),
          _buildReportCard(context, "Productos Vendidos", Icons.shopping_cart, () => context.push('/reports/productos-vendidos')),
          const SizedBox(height: 12),
          _buildReportCard(context, "Inventario General", Icons.inventory, () => context.push('/reports/inventario')),
          const SizedBox(height: 12),
          _buildReportCard(context, "Lotes", Icons.ballot, () => context.push('/reports/lotes')),
          const SizedBox(height: 12),
          _buildReportCard(context, "Próximos a Vencer", Icons.calendar_today_outlined, () => context.push('/reports/vencimientos')),
        ],
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
