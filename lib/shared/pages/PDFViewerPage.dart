import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:iventi/shared/services/PrintService.dart';

class PDFViewerPage extends StatelessWidget {
  final String filePath;
  const PDFViewerPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor de PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => PrintService.sharePDF(context, filePath),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => PrintService.downloadPDF(context, filePath),
          ),
        ],
      ),
      body: FutureBuilder<Uint8List>(
        future: File(filePath).readAsBytes().then((v) => Uint8List.fromList(v)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PdfPreview(
              build: (format) => snapshot.data!,
              allowPrinting: true,
              allowSharing: false,
              canChangePageFormat: false,
              canChangeOrientation: false,
              maxPageWidth: MediaQuery.of(context).size.width * 0.9,
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar el PDF: ${snapshot.error}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
