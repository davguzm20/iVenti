import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/AppRoutes.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  final isTest = binding.runtimeType.toString().contains('Test');

  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    debugPrint('FlutterError: ${details.exception}');
    previousOnError?.call(details);
  };

  if (!isTest) {
    ErrorWidget.builder = (details) => const Center(
          child: Text('Ha ocurrido un error inesperado'),
        );
  }

  await dotenv.load(fileName: ".env");

  await ServiceLocator.initialize();
  await DialogMessages.init();

  runApp(
    MultiProvider(
      providers: ServiceLocator.providers,
      child: const iVentiApp(),
    ),
  );
}

class iVentiApp extends StatelessWidget {
  const iVentiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'iVenti',
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
