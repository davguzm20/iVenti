import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';
import 'package:iventi/features/auth/dtos/requests/LoginRequest.dart';
import 'package:iventi/features/auth/repositories/UsuarioRepository.dart';

class AuthService {
  final UsuarioRepository _usuarioRepository;

  AuthService(this._usuarioRepository);

  Future<UsuarioEntity> iniciarSesion(String email, String pin) async {
    try {
      final request = LoginRequest(email: email, pin: pin);
      return await _usuarioRepository.validarCredenciales(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al iniciar sesion: ${e.mensaje}');
    }
  }

  Future<UsuarioEntity> registrar(CrearUsuarioRequest request) async {
    final usuarioExistente = await _usuarioRepository.obtenerUsuarioPorEmail(request.email);

    if (usuarioExistente != null) {
      throw BusinessException('El email ya esta registrado');
    }

    try {
      return await _usuarioRepository.crearUsuario(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al registrar usuario: ${e.mensaje}');
    }
  }

  Future<UsuarioEntity> obtenerUsuarioPorId(int idUsuario) async {
    try {
      final usuario = await _usuarioRepository.obtenerUsuarioPorId(idUsuario);

      if (usuario == null) {
        throw BusinessException('Usuario no encontrado');
      }

      return usuario;

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener usuario: ${e.mensaje}');
    }
  }

  Future<UsuarioEntity> obtenerUsuarioPorEmail(String email) async {
    try {
      final usuario = await _usuarioRepository.obtenerUsuarioPorEmail(email);

      if (usuario == null) {
        throw BusinessException('Usuario no encontrado');
      }

      return usuario;

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener usuario: ${e.mensaje}');
    }
  }

  Future<void> cambiarPin(int idUsuario, String pinActual, String pinNuevo) async {
    if (pinNuevo.length != 6) {
      throw ValidationException('El nuevo PIN debe tener 6 digitos');
    }

    final usuario = await obtenerUsuarioPorId(idUsuario);

    if (usuario.pin != pinActual) {
      throw BusinessException('El PIN actual es incorrecto');
    }

    try {
      await _usuarioRepository.actualizarPIN(idUsuario, pinNuevo);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al cambiar PIN: ${e.mensaje}');
    }
  }

  Future<UsuarioEntity> obtenerUsuarioRegistrado() async {
    return await _usuarioRepository.obtenerUsuarioRegistrado();
  }

  Future<void> recuperarPin(int idUsuario, String pinNuevo) async {
    if (pinNuevo.length != 6) {
      throw ValidationException('El PIN debe tener 6 digitos');
    }

    try {
      await _usuarioRepository.actualizarPIN(idUsuario, pinNuevo);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al recuperar PIN: ${e.mensaje}');
    }
  }

  Future<UsuarioEntity> actualizarPerfil(int idUsuario, {String? nombre, String? email}) async {
    try {
      return await _usuarioRepository.actualizarUsuario(idUsuario, nombre: nombre, email: email);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al actualizar perfil: ${e.mensaje}');
    }
  }

  Future<void> desactivarUsuario(int idUsuario) async {
    try {
      await _usuarioRepository.desactivarUsuario(idUsuario);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al desactivar usuario: ${e.mensaje}');
    }
  }
}
