import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iventi/shared/datasource/PostgresDatasource.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");

  final datasource = PostgresDatasource();
  try {
    final conn = await datasource.connection;
    print('Conexión exitosa: ${conn.runtimeType}');
    await datasource.close();
  } catch (e) {
    print('Error de conexión: $e');
  }
}
