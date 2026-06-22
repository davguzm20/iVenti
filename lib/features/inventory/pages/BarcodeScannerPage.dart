import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  static String? testCodigoSimulado;

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  MobileScannerController? _controller;
  bool _scanned = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear código'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(null),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                if (_scanned) return;
                final barcode = capture.barcodes.firstOrNull;
                final code = barcode?.rawValue;
                if (code != null && code.isNotEmpty) {
                  _scanned = true;
                  _controller?.stop();
                  if (context.mounted) context.pop(code);
                }
              },
            ),
          ),
          if (BarcodeScannerPage.testCodigoSimulado != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: () {
                  if (context.mounted) context.pop(BarcodeScannerPage.testCodigoSimulado);
                },
                child: const Text('Simular escaneo (testing)'),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.black54,
            child: const Center(
              child: Text(
                'Enfoca el código de barras',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
