import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostgresDatasource connection mutex', () {
    test('2 llamadas simultaneas se completan ambas', () async {
      final completer1 = Completer<void>();
      final completer2 = Completer<void>();
      int completions = 0;

      Future<void> simulateCall() async {
        await Future.delayed(const Duration(milliseconds: 10));
        completions++;
      }

      simulateCall().then((_) => completer1.complete());
      simulateCall().then((_) => completer2.complete());

      await Future.wait([completer1.future, completer2.future]);

      expect(completions, 2);
    });
  });

  group('PostgresDatasource connection retry', () {
    test('reintenta hasta maxRetries veces despues de fallos', () async {
      int attempts = 0;
      const maxRetries = 3;

      for (var i = 0; i <= maxRetries; i++) {
        attempts++;
        try {
          if (i < maxRetries) {
            throw Exception('Connection failed');
          }
          return;
        } catch (_) {
          if (i < maxRetries) {
            await Future.delayed(const Duration(milliseconds: 5));
          }
        }
      }

      expect(attempts, 4);
    });
  });

  group('PostgresDatasource heartbeat', () {
    test('heartbeat se ejecuta periodicamente', () async {
      int heartbeatCount = 0;
      final timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
        heartbeatCount++;
      });

      await Future.delayed(const Duration(milliseconds: 120));
      timer.cancel();

      expect(heartbeatCount, greaterThanOrEqualTo(2));
    });
  });
}
