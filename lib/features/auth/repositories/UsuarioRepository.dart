import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/AuthenticationException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/requests/LoginRequest.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';
import 'package:iventi/features/auth/mappers/UsuarioMapper.dart';
import 'package:iventi/features/auth/repositories/IUsuarioRepository.dart';

class UsuarioRepository implements IUsuarioRepository {
  final PostgresDatasource _datasource;

  UsuarioRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  @override
  Future<UsuarioEntity> crearUsuario(CrearUsuarioRequest request) async {
    final conexion = await _conexion;

    try {
      final usuarioCreado = await conexion.execute(
        Sql.named('INSERT INTO usuarios (rol, nombre, email, pin, creado_en, actualizado_en) VALUES (@rol, @nombre, @email, @pin, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING *'),
        parameters: {
          'rol': request.rol.name,
          'nombre': request.nombre.trim(),
          'email': request.email.trim(),
          'pin': request.pin,
        },
      );

      return UsuarioMapper.fromMap(usuarioCreado.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al crear usuario: $e');
    }
  }

  @override
  Future<UsuarioEntity?> obtenerUsuarioPorEmail(String email) async {
    final conexion = await _conexion;

    try {
      final usuariosEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM usuarios WHERE email = @email AND es_activo = TRUE'),
        parameters: {'email': email.trim()},
      );

      if (usuariosEncontrados.isEmpty) return null;

      return UsuarioMapper.fromMap(usuariosEncontrados.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('No se pudo consultar el usuario: $e');
    }
  }

  @override
  Future<UsuarioEntity?> obtenerUsuarioPorId(int idUsuario) async {
    final conexion = await _conexion;

    try {
      final usuariosEncontrados = await conexion.execute(
        Sql.named('SELECT * FROM usuarios WHERE id_usuario = @id AND es_activo = TRUE'),
        parameters: {'id': idUsuario},
      );

      if (usuariosEncontrados.isEmpty) return null;

      return UsuarioMapper.fromMap(usuariosEncontrados.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('No se pudo consultar el usuario: $e');
    }
  }

  @override
  Future<UsuarioEntity> validarCredenciales(LoginRequest request) async {
    final usuarioEncontrado = await obtenerUsuarioPorEmail(request.email);

    if (usuarioEncontrado == null) {
      throw AuthenticationException('No encontramos una cuenta con este correo.');
    }

    if (usuarioEncontrado.pin != request.pin) {
      throw AuthenticationException('El PIN que ingresaste no es correcto.');
    }

    return usuarioEncontrado;
  }

  @override
  Future<void> actualizarPIN(int idUsuario, String nuevoPIN) async {
    final conexion = await _conexion;

    try {
      final pinActualizado = await conexion.execute(
        Sql.named('UPDATE usuarios SET pin = @pin, actualizado_en = CURRENT_TIMESTAMP WHERE id_usuario = @id AND es_activo = TRUE'),
        parameters: {'pin': nuevoPIN, 'id': idUsuario},
      );

      if (pinActualizado.affectedRows == 0) {
        throw NotFoundException('No encontramos tu cuenta.');
      }
    } catch (e) {
      if (e is NotFoundException || e is ValidationException) rethrow;

      throw DatabaseException('No se pudo actualizar el PIN: $e');
    }
  }

  @override
  Future<UsuarioEntity> obtenerUsuarioRegistrado() async {
    final conexion = await _conexion;

    try {
      final usuariosEncontrados = await conexion.execute(
        'SELECT * FROM usuarios WHERE es_activo = TRUE ORDER BY id_usuario ASC LIMIT 1',
      );

      if (usuariosEncontrados.isEmpty) {
        throw NotFoundException('Aún no hay usuarios registrados.');
      }

      return UsuarioMapper.fromMap(usuariosEncontrados.first.toColumnMap());

    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('No se pudo consultar los usuarios registrados: $e');
    }
  }

  @override
  Future<UsuarioEntity> actualizarUsuario(int idUsuario, {required String nombre, String? email}) async {
    final conexion = await _conexion;

    try {
      final usuarioActualizado = await conexion.execute(
        Sql.named('UPDATE usuarios SET nombre = @nombre, email = @email, actualizado_en = CURRENT_TIMESTAMP WHERE id_usuario = @id AND es_activo = TRUE RETURNING *'),
        parameters: {'nombre': nombre, 'email': email, 'id': idUsuario},
      );

      if (usuarioActualizado.isEmpty) {
        throw NotFoundException('No encontramos tu cuenta.');
      }

      return UsuarioMapper.fromMap(usuarioActualizado.first.toColumnMap());
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('No se pudo actualizar tus datos: $e');
    }
  }

  @override
  Future<void> desactivarUsuario(int idUsuario) async {
    final conexion = await _conexion;

    try {
      final usuarioDesactivado = await conexion.execute(
        Sql.named('UPDATE usuarios SET es_activo = FALSE, actualizado_en = CURRENT_TIMESTAMP WHERE id_usuario = @id AND es_activo = TRUE'),
        parameters: {'id': idUsuario},
      );

      if (usuarioDesactivado.affectedRows == 0) {
        throw NotFoundException('No encontramos tu cuenta.');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('No se pudo desactivar la cuenta: $e');
    }
  }
}
