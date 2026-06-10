import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';

class ImagePickerPage extends StatelessWidget {
  const ImagePickerPage({super.key});

  static String? testRutaSimulada;

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    if (testRutaSimulada != null) {
      if (context.mounted) context.pop(testRutaSimulada);
      return;
    }
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: source, imageQuality: 85);
    if (xFile != null && context.mounted) {
      context.pop(xFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar imagen'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(null),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            Icon(Icons.image_outlined, size: 100, color: AppColors.primary.withAlpha(100)),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(context, ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined, size: 24),
                  label: const Text('Tomar foto', style: TextStyle(fontSize: 16)),
                  style: ButtonStyles.success(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(context, ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined, size: 24),
                  label: const Text('Elegir de galería', style: TextStyle(fontSize: 16)),
                  style: ButtonStyles.primary(),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
