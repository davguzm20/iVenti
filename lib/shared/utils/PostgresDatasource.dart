import 'dart:async';
import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';

class PostgresDatasource {
  static final PostgresDatasource _instance = PostgresDatasource._internal();
  factory PostgresDatasource() => _instance;
  PostgresDatasource._internal();

  Connection? _connection;
  int? _ultimoIdUsuario;
  Timer? _heartbeatTimer;
  Completer<void>? _initLock;

  Future<Connection> get connection async {
    if (_initLock != null) {
      try { await _initLock!.future; } catch (_) {}
    }

    if (_connection == null || !await _conexionActiva()) {
      final completer = Completer<void>();
      _initLock = completer;
      try {
        if (_connection != null) {
          try {           await _connection!.close(); } catch (_) {}
          _connection = null;
          _ultimoIdUsuario = null;
        }
        await _initWithRetry();
        _startHeartbeat();
      } finally {
        _initLock = null;
        completer.complete();
      }
    }
    final idUsuario = ServiceLocator.usuarioActualId;
    if (idUsuario != null && idUsuario != _ultimoIdUsuario) {
      await _connection!.execute('SET app.id_usuario = $idUsuario');
      _ultimoIdUsuario = idUsuario;
    }
    return _connection!;
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      try {
        await _connection?.execute('SELECT 1');
      } catch (_) {}
    });
  }

  Future<bool> _conexionActiva() async {
    try {
      await _connection!.execute('SELECT 1');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _initWithRetry() async {
    for (var i = 0; i < 3; i++) {
      try {
        await _initConnection();
        return;
      } catch (_) {
        if (i < 2) await Future.delayed(const Duration(seconds: 1));
      }
    }
    await _initConnection();
  }

  Future<void> _initConnection() async {
    final host = dotenv.env['PGHOST'] ?? '';
    final port = int.parse(dotenv.env['PGPORT'] ?? '');
    final db = dotenv.env['PGDATABASE'] ?? '';
    final user = dotenv.env['PGUSER'] ?? '';
    final password = dotenv.env['PGPASSWORD'] ?? '';

    _connection = await Connection.open(
      Endpoint(
        host: host,
        port: port,
        database: db,
        username: user,
        password: password,
      ),
      settings: ConnectionSettings(sslMode: SslMode.require),
    );
  }

  Future<void> close() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    try { await _connection?.close(); } catch (_) {}
    _connection = null;
    _ultimoIdUsuario = null;
  }
}
