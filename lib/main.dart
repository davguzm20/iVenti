import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/AppRoutes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");

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
