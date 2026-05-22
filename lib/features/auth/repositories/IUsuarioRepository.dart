import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/requests/LoginRequest.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';

abstract class IUsuarioRepository {
  Future<UsuarioEntity> crearUsuario(CrearUsuarioRequest request);
  Future<UsuarioEntity?> obtenerUsuarioPorEmail(String email);
  Future<UsuarioEntity?> obtenerUsuarioPorId(int idUsuario);
  Future<UsuarioEntity> validarCredenciales(LoginRequest request);
  Future<void> actualizarPIN(int idUsuario, String nuevoPIN);
  Future<UsuarioEntity> obtenerUsuarioRegistrado();
  Future<UsuarioEntity> actualizarUsuario(int idUsuario, {String? nombre, String? email});
  Future<void> desactivarUsuario(int idUsuario);
}
