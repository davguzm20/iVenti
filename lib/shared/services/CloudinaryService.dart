import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class CloudinaryService {
  Cloudinary? _cloudinary;
  static final CloudinaryService _instance = CloudinaryService._();
  CloudinaryService._();
  factory CloudinaryService() => _instance;

  static const maxImageSize = 5 * 1024 * 1024;
  static const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  Cloudinary get _client {
    if (_cloudinary != null) return _cloudinary!;
    final url = dotenv.env['CLOUDINARY_URL']!;
    final parts = url.replaceFirst('cloudinary://', '').split('@');
    final credentials = parts[0].split(':');
    final cloudName = parts[1];
    _cloudinary = Cloudinary.full(
      cloudName: cloudName,
      apiKey: credentials[0],
      apiSecret: credentials[1],
    );
    return _cloudinary!;
  }

  Future<String> uploadImage(String filePath, int productId) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('El archivo no existe');
    }
    final size = await file.length();
    if (size > maxImageSize) {
      throw Exception('La imagen supera el limite de 5MB');
    }
    final ext = filePath.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(ext)) {
      throw Exception('Formato no permitido. Usa jpg, png o webp');
    }
    final response = await _client.uploadResource(
      CloudinaryUploadResource(
        filePath: filePath,
        folder: 'productos',
        publicId: 'producto_$productId',
        resourceType: CloudinaryResourceType.image,
      ),
    );
    if (response.secureUrl == null) {
      throw Exception('Error al subir la imagen a Cloudinary');
    }
    return response.secureUrl!;
  }
}
