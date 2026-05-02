import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostgresDatasource {
  static final PostgresDatasource _instance = PostgresDatasource._internal();
  factory PostgresDatasource() => _instance;
  PostgresDatasource._internal();

  Connection? _connection;

  Future<Connection> get connection async {
    if (_connection == null) {
      await _initConnection();
    }
    return _connection!;
  }

  Future<void> _initConnection() async {
    await dotenv.load(fileName: 'lib/.env');

    final host = dotenv.env['POSTGRES_HOST'] ?? '';
    final port = int.parse(dotenv.env['POSTGRES_PORT'] ?? '');
    final db = dotenv.env['POSTGRES_DB'] ?? '';
    final user = dotenv.env['POSTGRES_USER'] ?? '';
    final password = dotenv.env['POSTGRES_PASSWORD'] ?? '';

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
