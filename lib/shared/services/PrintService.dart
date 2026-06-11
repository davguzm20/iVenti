import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';

class PrintService {
  PrintService._();

  static Future<String> generarBoletaPDF({
    required VentaEntity venta,
    required List<DetalleVentaEntity> detalles,
    required String? clienteNombre,
    required String? clienteDni,
  }) async {
    final pdf = pw.Document();
    final codigoBoleta = venta.codigoBoleta ?? '---';
    final nombreCliente = clienteNombre ?? '---';
    final dniCliente = clienteDni ?? '---';
    final tipoPago = venta.esCredito ? 'Credito' : 'Al contado';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      children: [
                        pw.Text('Multiservicios Golden',
                            style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(10),
                            border: pw.Border.all(
                              color: PdfColor.fromHex('#0e5087'),
                              width: 1,
                            ),
                          ),
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Column(children: [
                            pw.Text('De: Golden Corp S.A.C.')
                          ]),
                        ),
                        pw.Text(
                          'VENTA DE ABARROTES, ARTICULOS DE\nFERRETERIA, LIBRERIA Y OTROS',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          'Av. Los Proceres 123, Lima - Lima - Lima',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text('Cel.: 999000111'),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(10),
                            border: pw.Border.all(
                              color: PdfColor.fromHex('#0e5087'),
                              width: 2,
                            ),
                          ),
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Text(
                                'R.U.C N 20123456789',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#0e5087'),
                                  fontSize: 18,
                                ),
                              ),
                              pw.Text(
                                'BOLETA DE VENTA',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#0e5087'),
                                  fontSize: 18,
                                ),
                              ),
                              pw.Text(
                                codigoBoleta,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#0e5087'),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              color: PdfColor.fromHex('#0e5087'),
                              width: 2,
                            ),
                          ),
                          child: pw.Column(children: [
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.Container(
                                    color: PdfColor.fromHex('#0e5087'),
                                    padding: pw.EdgeInsets.symmetric(
                                        vertical: 5),
                                    alignment: pw.Alignment.center,
                                    child: pw.Text(
                                      'DIA',
                                      style: pw.TextStyle(
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 2,
                                  color: PdfColor.fromHex('#0e5087'),
                                ),
                                pw.Expanded(
                                  child: pw.Container(
                                    color: PdfColor.fromHex('#0e5087'),
                                    padding: pw.EdgeInsets.symmetric(
                                        vertical: 5),
                                    alignment: pw.Alignment.center,
                                    child: pw.Text(
                                      'MES',
                                      style: pw.TextStyle(
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 2,
                                  color: PdfColor.fromHex('#0e5087'),
                                ),
                                pw.Expanded(
                                  child: pw.Container(
                                    color: PdfColor.fromHex('#0e5087'),
                                    padding: pw.EdgeInsets.symmetric(
                                        vertical: 5),
                                    alignment: pw.Alignment.center,
                                    child: pw.Text(
                                      'ANO',
                                      style: pw.TextStyle(
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.symmetric(
                                        vertical: 5),
                                    alignment: pw.Alignment.center,
                                    child: pw.Text(
                                      venta.vendidoEn.day
                                          .toString()
                                          .padLeft(2, '0'),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 2,
                                  color: PdfColor.fromHex('#0e5087'),
                                ),
                                pw.Expanded(
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.symmetric(
                                        vertical: 5),
                                    alignment: pw.Alignment.center,
                                    child: pw.Text(
                                      venta.vendidoEn.month
                                          .toString()
                                          .padLeft(2, '0'),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 2,
                                  color: PdfColor.fromHex('#0e5087'),
                                ),
                                pw.Expanded(
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.symmetric(
                                        vertical: 5),
                                    alignment: pw.Alignment.center,
                                    child: pw.Text(
                                      venta.vendidoEn.year.toString(),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Text('Cliente: $nombreCliente'),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [pw.Text('Dni: $dniCliente')]),
              pw.Text('Forma de pago: $tipoPago'),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FixedColumnWidth(50),
                  1: pw.FlexColumnWidth(),
                  2: pw.FixedColumnWidth(80),
                  3: pw.FixedColumnWidth(80),
                },
                headers: [
                  pw.Text('CANT.', textAlign: pw.TextAlign.center),
                  pw.Text('DESCRIPCION', textAlign: pw.TextAlign.center),
                  pw.Text('P. UNIT.', textAlign: pw.TextAlign.center),
                  pw.Text('TOTAL', textAlign: pw.TextAlign.center),
                ],
                data: detalles.map((d) => [
                      '${d.cantidad}',
                      'Producto ${d.idLote}',
                      d.precioUnitario.toStringAsFixed(2),
                      d.subtotal.toStringAsFixed(2),
                    ]).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                      'MONTO TOTAL S/ ${venta.montoTotal.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold))),
              if (venta.esCredito) ...[
                if (venta.montoCancelado >= venta.montoTotal)
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'ESTADO CANCELADO',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold),
                    ),
                  )
                else ...[
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'MONTO CANCELADO S/ ${venta.montoCancelado.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'MONTO POR PAGAR S/ ${(venta.montoTotal - venta.montoCancelado).toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ],
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/boleta_${codigoBoleta}_$timestamp.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static Future<String> generarReportePDF({
    required String titulo,
    required List<String> headers,
    required List<List<String>> data,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Multiservicios Golden',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 8),
          pw.Text(titulo,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text('Generado: ${DateTime.now().toString().split('.')[0]}',
              style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headers: headers,
            data: data,
          ),
        ],
      ),
    );
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/reporte_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static Future<void> sharePDF(BuildContext context, String path, {String mensaje = 'Aqui tienes el PDF'}) async {
    try {
      await Share.shareXFiles([XFile(path)], text: mensaje);
      await Share.shareXFiles([XFile(path)], text: mensaje);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al compartir el PDF: $e')),
        );
      }
    }
  }

  static Future<void> downloadPDF(BuildContext context, String path) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = path.split('/').last;
      final newPath = '${dir.path}/$fileName';
      await File(path).copy(newPath);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF guardado en: $newPath')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar el PDF: $e')),
        );
      }
    }
  }
}
