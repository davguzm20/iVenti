import 'package:postgres/postgres.dart';
import 'package:iventi/shared/datasources/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/AuthenticationException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/requests/LoginRequest.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';
import 'package:iventi/features/auth/mappers/UsuarioMapper.dart';

class UsuarioRepository {
  final PostgresDatasource _datasource;

  UsuarioRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  Future<UsuarioEntity> crearUsuario(CrearUsuarioRequest request) async {
    final conexion = await _conexion;

    try {
      final usuarioCreado = await conexion.execute(
        Sql.named('INSERT INTO usuarios (id_rol, nombre, email, pin, creado_en, actualizado_en) VALUES (@id_rol, @nombre, @email, @pin, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING *'),
        parameters: {
          'id_rol': request.idRol.name,
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
      throw DatabaseException('Error al obtener usuario: $e');
    }
  }

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
      throw DatabaseException('Error al obtener usuario: $e');
    }
  }

  Future<UsuarioEntity> validarCredenciales(LoginRequest request) async {
    final usuarioEncontrado = await obtenerUsuarioPorEmail(request.email);

    if (usuarioEncontrado == null) {
      throw AuthenticationException('Usuario no encontrado');
    }

    if (usuarioEncontrado.pin != request.pin) {
      throw AuthenticationException('PIN incorrecto');
    }

    return usuarioEncontrado;
  }

  Future<void> actualizarPIN(int idUsuario, String nuevoPIN) async {
    final conexion = await _conexion;

    try {
      if (nuevoPIN.length != 6) {
        throw ValidationException('El PIN debe tener 6 digitos');
      }

      final pinActualizado = await conexion.execute(
        Sql.named('UPDATE usuarios SET pin = @pin, actualizado_en = CURRENT_TIMESTAMP WHERE id_usuario = @id AND es_activo = TRUE'),
        parameters: {'pin': nuevoPIN, 'id': idUsuario},
      );

      if (pinActualizado.affectedRows == 0) {
        throw NotFoundException('Usuario no encontrado');
      }
    } catch (e) {
      if (e is NotFoundException || e is ValidationException) rethrow;

      throw DatabaseException('Error al actualizar PIN: $e');
    }
  }

  Future<UsuarioEntity> actualizarUsuario(int idUsuario, {String? nombre, String? email}) async {
    final conexion = await _conexion;

    try {
      final usuarioActualizado = await conexion.execute(
        Sql.named('UPDATE usuarios SET nombre = @nombre, email = @email, actualizado_en = CURRENT_TIMESTAMP WHERE id_usuario = @id AND es_activo = TRUE RETURNING *'),
        parameters: {'nombre': nombre, 'email': email, 'id': idUsuario},
      );

      if (usuarioActualizado.isEmpty) {
        throw NotFoundException('Usuario no encontrado');
      }

      return UsuarioMapper.fromMap(usuarioActualizado.first.toColumnMap());
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al actualizar usuario: $e');
    }
  }

  Future<void> desactivarUsuario(int idUsuario) async {
    final conexion = await _conexion;

    try {
      final usuarioDesactivado = await conexion.execute(
        Sql.named('UPDATE usuarios SET es_activo = FALSE, actualizado_en = CURRENT_TIMESTAMP WHERE id_usuario = @id AND es_activo = TRUE'),
        parameters: {'id': idUsuario},
      );

      if (usuarioDesactivado.affectedRows == 0) {
        throw NotFoundException('Usuario no encontrado');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al desactivar usuario: $e');
    }
  }
}
