import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Future<void> pumpPage(
  WidgetTester tester, {
  required Widget page,
  required List<Provider> providers,
}) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: providers,
      child: MaterialApp(home: page),
    ),
  );
}
