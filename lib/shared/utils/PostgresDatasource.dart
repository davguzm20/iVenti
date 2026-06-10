import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';

class PostgresDatasource {
  static final PostgresDatasource _instance = PostgresDatasource._internal();
  factory PostgresDatasource() => _instance;
  PostgresDatasource._internal();

  Connection? _connection;
  int? _ultimoIdUsuario;

  Future<Connection> get connection async {
    if (_connection == null || !await _conexionActiva()) {
      if (_connection != null) {
        await _connection!.close();
        _connection = null;
      }
      await _initConnection();
    }
    final idUsuario = ServiceLocator.usuarioActualId;
    if (idUsuario != null && idUsuario != _ultimoIdUsuario) {
      await _connection!.execute('SET app.id_usuario = $idUsuario');
      _ultimoIdUsuario = idUsuario;
    }
    return _connection!;
  }

  Future<bool> _conexionActiva() async {
    try {
      await _connection!.execute('SELECT 1');
      return true;
    } catch (_) {
      return false;
    }
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
    await _connection?.close();
    _connection = null;
  }
}
