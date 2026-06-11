import 'package:iventi/shared/utils/PinEncryptor.dart';
import 'package:iventi/shared/exceptions/AuthenticationException.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';
import 'package:iventi/features/auth/dtos/requests/LoginRequest.dart';
import 'package:iventi/features/auth/repositories/IUsuarioRepository.dart';

class AuthService {
  final IUsuarioRepository _usuarioRepository;

  AuthService(this._usuarioRepository);

  Future<UsuarioEntity> iniciarSesion(String email, String pin) async {
    try {
      final request = LoginRequest(email: email, pin: PinEncryptor.hash(pin));
      try {
        return await _usuarioRepository.validarCredenciales(request);
      } on AuthenticationException {
        final legacyRequest = LoginRequest(email: email, pin: PinEncryptor.hashLegacy(pin));
        final usuario = await _usuarioRepository.validarCredenciales(legacyRequest);
        await _usuarioRepository.actualizarPIN(usuario.idUsuario!, PinEncryptor.hash(pin));
        return usuario;
      }

    } on DatabaseException {
      throw BusinessException(
        'Error de conexión',
        descripcion: 'No pudimos conectar con la base de datos. Verifica tu conexión a internet y vuelve a intentarlo. Si el problema persiste, contacta al soporte técnico.',
      );
    }
  }

  Future<UsuarioEntity> registrar(CrearUsuarioRequest request) async {
    final usuarioExistente = await _usuarioRepository.obtenerUsuarioPorEmail(request.email);

    if (usuarioExistente != null) {
      throw BusinessException(
        'Correo ya registrado',
        descripcion: 'Este correo ya tiene una cuenta. Si olvidaste tu PIN, toca "¿Olvidaste tu PIN?" en la pantalla de inicio de sesión.',
      );
    }

    try {
      final hashedRequest = CrearUsuarioRequest(
        nombre: request.nombre,
        email: request.email,
        pin: PinEncryptor.hash(request.pin),
        rol: request.rol,
      );
      return await _usuarioRepository.crearUsuario(hashedRequest);

    } on DatabaseException {
      throw BusinessException(
        'Error de conexión',
        descripcion: 'No pudimos completar el registro. Verifica tu conexión a internet y vuelve a intentarlo.',
      );
    }
  }

  Future<UsuarioEntity> obtenerUsuarioPorId(int idUsuario) async {
    try {
      final usuario = await _usuarioRepository.obtenerUsuarioPorId(idUsuario);

      if (usuario == null) {
        throw BusinessException(
          'Cuenta no encontrada',
          descripcion: 'Es posible que la cuenta haya sido desactivada. Contacta al administrador si crees que esto es un error.',
        );
      }

      return usuario;

    } on DatabaseException {
      throw BusinessException(
        'Error de conexión',
        descripcion: 'No pudimos verificar tu información. Revisa tu conexión a internet y vuelve a intentarlo.',
      );
    }
  }

  Future<UsuarioEntity> obtenerUsuarioPorEmail(String email) async {
    try {
      final usuario = await _usuarioRepository.obtenerUsuarioPorEmail(email);

      if (usuario == null) {
        throw BusinessException(
          'Correo no registrado',
          descripcion: 'No encontramos una cuenta con este correo. Si aún no te registras, toca "¿Eres nuevo?" en la pantalla de bienvenida.',
        );
      }

      return usuario;

    } on DatabaseException {
      throw BusinessException(
        'Error de conexión',
        descripcion: 'No pudimos verificar tu información. Revisa tu conexión a internet y vuelve a intentarlo.',
      );
    }
  }

  Future<void> cambiarPin(int idUsuario, String pinActual, String pinNuevo) async {
    if (pinNuevo.length != 6) {
      throw ValidationException(
        'PIN inválido',
        descripcion: 'El PIN debe tener exactamente 6 dígitos numéricos.',
      );
    }

    final usuario = await obtenerUsuarioPorId(idUsuario);

    if (usuario.pin != PinEncryptor.hash(pinActual) && usuario.pin != PinEncryptor.hashLegacy(pinActual)) {
      throw BusinessException(
        'PIN incorrecto',
        descripcion: 'El PIN actual que ingresaste no coincide. Verifica e intenta de nuevo.',
      );
    }

    try {
      await _usuarioRepository.actualizarPIN(idUsuario, PinEncryptor.hash(pinNuevo));

    } on DatabaseException {
      throw BusinessException(
        'Error de conexión',
        descripcion: 'No pudimos actualizar tu PIN. Verifica tu conexión a internet y vuelve a intentarlo.',
      );
    }
  }

  Future<UsuarioEntity> obtenerUsuarioRegistrado() async {
    try {
      return await _usuarioRepository.obtenerUsuarioRegistrado();
    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener usuario registrado: ${e.mensaje}');
    }
  }

  Future<void> recuperarPin(int idUsuario, String pinNuevo) async {
    if (pinNuevo.length != 6) {
      throw ValidationException(
        'PIN inválido',
        descripcion: 'El PIN debe tener exactamente 6 dígitos numéricos.',
      );
    }

    try {
      await _usuarioRepository.actualizarPIN(idUsuario, PinEncryptor.hash(pinNuevo));

    } on DatabaseException {
      throw BusinessException(
        'Error de conexión',
        descripcion: 'No pudimos recuperar tu PIN. Verifica tu conexión a internet y vuelve a intentarlo.',
      );
    }
  }

  Future<UsuarioEntity> actualizarPerfil(int idUsuario, {String? nombre, String? email}) async {
    try {
      return await _usuarioRepository.actualizarUsuario(idUsuario, nombre: nombre, email: email);

    } on DatabaseException {
      throw BusinessException(
        'Error de conexión',
        descripcion: 'No pudimos guardar los cambios. Verifica tu conexión a internet y vuelve a intentarlo.',
      );
    }
  }

  Future<void> desactivarUsuario(int idUsuario) async {
    try {
      await _usuarioRepository.desactivarUsuario(idUsuario);

    } on DatabaseException {
      throw BusinessException(
        'Error de conexión',
        descripcion: 'No pudimos desactivar la cuenta. Verifica tu conexión a internet y vuelve a intentarlo.',
      );
    }
  }
}
