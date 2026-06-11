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
            icon: const Icon(Icons.print, color: Colors.black),
            onPressed: () => Printing.layoutPdf(
              onLayout: (_) => File(filePath).readAsBytesSync(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () => PrintService.sharePDF(context, filePath),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black),
            onPressed: () => PrintService.downloadPDF(context, filePath),
          ),
        ],
      ),
      body: FutureBuilder<Uint8List>(
        future: File(filePath).readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PdfPreview(
              build: (format) => snapshot.data!,
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              canChangeOrientation: false,
              maxPageWidth: MediaQuery.of(context).size.width,
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
