import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/features/auth/repositories/UsuarioRepository.dart';
import 'package:iventi/features/auth/services/AuthService.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';

class AuthModule {
  static late final UsuarioRepository usuarioRepository;
  static late final AuthService authService;
  static late final AuthController authController;

  static void register(PostgresDatasource datasource) {
    usuarioRepository = UsuarioRepository(datasource);
    authService = AuthService(usuarioRepository);
    authController = AuthController(authService);
  }
}
