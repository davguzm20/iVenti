import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/services/PrintService.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';

class ReportResultsPage extends StatelessWidget {
  final String titulo;
  final List<String> headers;
  final List<List<String>> data;

  const ReportResultsPage({
    super.key,
    required this.titulo,
    required this.headers,
    required this.data,
  });

  Future<void> _imprimir(BuildContext context) async {
    try {
      final path = await PrintService.generarReportePDF(
        titulo: titulo,
        headers: headers,
        data: data,
      );
      if (context.mounted) {
        await context.push('/pdf-viewer', extra: path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar PDF: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          if (data.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Generar PDF',
              onPressed: () => _imprimir(context),
            ),
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Compartir PDF',
              onPressed: () async {
                final path = await PrintService.generarReportePDF(
                  titulo: titulo,
                  headers: headers,
                  data: data,
                );
                if (!context.mounted) return;
                await PrintService.sharePDF(
                  context,
                  path,
                  mensaje: 'Reporte: $titulo',
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Descargar PDF',
              onPressed: () async {
                final path = await PrintService.generarReportePDF(
                  titulo: titulo,
                  headers: headers,
                  data: data,
                );
                if (!context.mounted) return;
                await PrintService.downloadPDF(context, path);
              },
            ),
          ],
        ],
      ),
      body: data.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No se encontraron datos', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ButtonStyles.primary(),
                    onPressed: () => context.pop(),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: headers.map((h) => DataColumn(label: Text(h, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)))).toList(),
                  rows: data.asMap().entries.map((entry) {
                    final idx = entry.key + 1;
                    final row = entry.value;
                    return DataRow(cells: [
                      DataCell(Text('$idx')),
                      ...row.map((cell) => DataCell(Text(cell))),
                    ]);
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
