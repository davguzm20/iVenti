import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/auth/services/AuthService.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/enums/TipoRol.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/utils/PinEncryptor.dart';
import 'package:iventi/shared/utils/DniEncryptor.dart';

import '../../mocks_mocks.dart';

void main() {
  late MockIUsuarioRepository mockRepo;
  late AuthService authService;

  setUpAll(() async {
    await dotenv.load(fileName: '.env.test');
  });

  setUp(() {
    mockRepo = MockIUsuarioRepository();
    authService = AuthService(mockRepo);
  });

  group('AuthService HMAC-SHA256 PIN', () {
    test('login usa PinEncryptor.hash para comparar PIN', () async {
      final usuario = UsuarioEntity(
        idUsuario: 1,
        rol: TipoRol.OPERATIVO,
        nombre: 'Test',
        email: 'test@test.com',
        pin: PinEncryptor.hash('123456'),
        creadoEn: DateTime.now(),
      );

      when(mockRepo.validarCredenciales(any)).thenAnswer((_) async => usuario);

      final result = await authService.iniciarSesion('test@test.com', '123456');

      expect(result, usuario);
    });

    test('login con PIN incorrecto lanza BusinessException', () async {
      when(mockRepo.validarCredenciales(any))
          .thenThrow(BusinessException('Credenciales invalidas'));

      expect(
        () => authService.iniciarSesion('test@test.com', '000000'),
        throwsA(isA<BusinessException>()),
      );
    });

    test('mismo PIN produce consistentemente el mismo hash', () {
      final h1 = PinEncryptor.hash('123456');
      final h2 = PinEncryptor.hash('123456');
      expect(h1, h2);
      expect(h1.length, 64);
    });
  });

  group('DniEncryptor integridad', () {
    test('encryptAES/decryptAES ciclo completo', () {
      final encrypted = DniEncryptor.encryptAES('12345678');
      final decrypted = DniEncryptor.decryptAES(encrypted);
      expect(decrypted, '12345678');
    });

    test('plaintext legacy retorna tal cual', () {
      expect(DniEncryptor.decryptAES('12345678'), '12345678');
    });
  });
}
