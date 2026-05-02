import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseConnection {
  static Connection? _connection;

  static Connection get connection {
    if (_connection == null) {
      _connection = Connection(
        Endpoint(
          host: dotenv.env['POSTGRES_HOST'] ?? 'localhost',
          port: int.parse(dotenv.env['POSTGRES_PORT'] ?? '5432'),
        ),
        SecurityContextValues(
          requireSsl: true,
          certificateBytes: null,
        ),
        Authentication(
          username: dotenv.env['POSTGRES_USER'] ?? 'postgres',
          password: dotenv.env['POSTGRES_PASSWORD'] ?? '',
          databaseName: dotenv.env['POSTGRES_DB'] ?? 'iventi_db',
        ),
      );
    }
    return _connection!;
  }

  static Future<void> closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }
}
