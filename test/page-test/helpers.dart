import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Widget _wrapProviders(Widget child, List<Provider> providers) {
  if (providers.isEmpty) return child;
  return MultiProvider(providers: providers, child: child);
}

Future<void> pumpPage(
  WidgetTester tester, {
  required Widget page,
  required List<Provider> providers,
}) async {
  await tester.pumpWidget(
    _wrapProviders(MaterialApp(home: page), providers),
  );
}

Future<void> pumpPageWithRouter(
  WidgetTester tester, {
  required String location,
  required Widget page,
  required List<Provider> providers,
}) async {
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(path: location, builder: (_, __) => page),
    ],
  );
  await tester.pumpWidget(
    _wrapProviders(MaterialApp.router(routerConfig: router), providers),
  );
}
