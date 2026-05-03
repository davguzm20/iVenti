import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';
import 'package:iventi/features/auth/services/AuthService.dart';

class AuthController {
  final AuthService _authService;

  AuthController(this._authService);

  Future<UsuarioEntity> iniciarSesion(String email, String pin) {
    return _authService.iniciarSesion(email, pin);
  }

  Future<UsuarioEntity> registrar(CrearUsuarioRequest request) {
    return _authService.registrar(request);
  }

  Future<void> cambiarPin(int idUsuario, String pinActual, String pinNuevo) {
    return _authService.cambiarPin(idUsuario, pinActual, pinNuevo);
  }

  Future<UsuarioEntity> actualizarPerfil(int idUsuario, {String? nombre, String? email}) {
    return _authService.actualizarPerfil(idUsuario, nombre: nombre, email: email);
  }

  Future<void> desactivarUsuario(int idUsuario) {
    return _authService.desactivarUsuario(idUsuario);
  }
}
