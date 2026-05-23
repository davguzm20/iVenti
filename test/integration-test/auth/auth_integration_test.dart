import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/AuthenticationException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/auth/repositories/UsuarioRepository.dart';
import 'package:iventi/features/auth/services/AuthService.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';

void main() {
  late PostgresDatasource datasource;
  late UsuarioRepository usuarioRepository;
  late AuthService authService;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    datasource = PostgresDatasource();
    usuarioRepository = UsuarioRepository(datasource);
    authService = AuthService(usuarioRepository);
  });

  setUp(() async {
    final conn = await datasource.connection;
    await conn.execute('BEGIN');
  });

  tearDown(() async {
    final conn = await datasource.connection;
    await conn.execute('ROLLBACK');
  });

  tearDownAll(() async {
    await datasource.close();
  });

  int _contador = 0;
  String _emailUnico() =>
      'test_${DateTime.now().millisecondsSinceEpoch}_${_contador++}@test.com';

  Future<UsuarioEntity> _crearUsuario({
    String? email,
    String pin = '123456',
  }) async {
    final request = CrearUsuarioRequest(
      nombre: 'Test User',
      email: email ?? _emailUnico(),
      pin: pin,
    );
    return await authService.registrar(request);
  }

  group('AuthService.registrar con BD real', () {
    test(
        'debe crear un usuario correctamente cuando los datos son validos [en BD real]',
        () async {
      final email = _emailUnico();
      final usuario = await _crearUsuario(email: email);

      expect(usuario.idUsuario, isNotNull);
      expect(usuario.nombre, 'Test User');
      expect(usuario.email, email);
      expect(usuario.esActivo, true);
      expect(usuario.pin, '123456');
      expect(usuario.rol.name, 'ADMINISTRADOR');
    });

    test(
        'debe lanzar BusinessException cuando el email ya esta registrado [en BD real]',
        () async {
      final email = _emailUnico();
      await _crearUsuario(email: email);

      expect(
        () => _crearUsuario(email: email),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.iniciarSesion con BD real', () {
    test(
        'debe iniciar sesion correctamente cuando las credenciales son validas [en BD real]',
        () async {
      final email = _emailUnico();
      final creado = await _crearUsuario(email: email, pin: '654321');

      final usuario = await authService.iniciarSesion(email, '654321');

      expect(usuario.idUsuario, creado.idUsuario);
      expect(usuario.email, email);
    });

    test(
        'debe lanzar AuthenticationException cuando el email no existe [en BD real]',
        () async {
      expect(
        () => authService.iniciarSesion('no_existe_${_emailUnico()}@test.com', '123456'),
        throwsA(isA<AuthenticationException>()),
      );
    });

    test(
        'debe lanzar AuthenticationException cuando el PIN es incorrecto [en BD real]',
        () async {
      final email = _emailUnico();
      await _crearUsuario(email: email, pin: '654321');

      expect(
        () => authService.iniciarSesion(email, '000000'),
        throwsA(isA<AuthenticationException>()),
      );
    });
  });

  group('AuthService.obtenerUsuarioPorId con BD real', () {
    test(
        'debe obtener un usuario por ID cuando existe [en BD real]',
        () async {
      final email = _emailUnico();
      final creado = await _crearUsuario(email: email);

      final usuario = await authService.obtenerUsuarioPorId(creado.idUsuario!);

      expect(usuario.idUsuario, creado.idUsuario);
      expect(usuario.email, email);
    });

    test(
        'debe lanzar BusinessException cuando el ID no existe [en BD real]',
        () async {
      expect(
        () => authService.obtenerUsuarioPorId(-1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.obtenerUsuarioPorEmail con BD real', () {
    test(
        'debe obtener un usuario por email cuando existe [en BD real]',
        () async {
      final email = _emailUnico();
      await _crearUsuario(email: email);

      final usuario = await authService.obtenerUsuarioPorEmail(email);

      expect(usuario.email, email);
    });

    test(
        'debe lanzar BusinessException cuando el email no existe [en BD real]',
        () async {
      expect(
        () => authService.obtenerUsuarioPorEmail('no_existe_${_emailUnico()}@test.com'),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.cambiarPin con BD real', () {
    test(
        'debe cambiar el PIN correctamente cuando el PIN actual es correcto [en BD real]',
        () async {
      final email = _emailUnico();
      final creado = await _crearUsuario(email: email, pin: '654321');

      await authService.cambiarPin(creado.idUsuario!, '654321', '123456');

      final usuario = await authService.iniciarSesion(email, '123456');
      expect(usuario.email, email);
    });

    test(
        'debe lanzar BusinessException cuando el PIN actual es incorrecto [en BD real]',
        () async {
      final email = _emailUnico();
      final creado = await _crearUsuario(email: email, pin: '654321');

      expect(
        () => authService.cambiarPin(creado.idUsuario!, '000000', '123456'),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.recuperarPin con BD real', () {
    test(
        'debe recuperar el PIN correctamente [en BD real]',
        () async {
      final email = _emailUnico();
      final creado = await _crearUsuario(email: email, pin: '654321');

      await authService.recuperarPin(creado.idUsuario!, '000000');

      final usuario = await authService.iniciarSesion(email, '000000');
      expect(usuario.email, email);
    });

    test(
        'debe lanzar ValidationException cuando el nuevo PIN no tiene 6 digitos [en BD real]',
        () async {
      final email = _emailUnico();
      final creado = await _crearUsuario(email: email);

      expect(
        () => authService.recuperarPin(creado.idUsuario!, '123'),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('AuthService.actualizarPerfil con BD real', () {
    test(
        'debe actualizar el perfil correctamente [en BD real]',
        () async {
      final email = _emailUnico();
      final creado = await _crearUsuario(email: email);

      final actualizado = await authService.actualizarPerfil(
        creado.idUsuario!,
        nombre: 'Nombre Actualizado',
        email: email,
      );

      expect(actualizado.nombre, 'Nombre Actualizado');
      expect(actualizado.email, email);
    });
  });

  group('AuthService.desactivarUsuario con BD real', () {
    test(
        'debe desactivar un usuario correctamente [en BD real]',
        () async {
      final email = _emailUnico();
      final creado = await _crearUsuario(email: email);

      await authService.desactivarUsuario(creado.idUsuario!);

      expect(
        () => authService.obtenerUsuarioPorId(creado.idUsuario!),
        throwsA(isA<BusinessException>()),
      );
    });

    test(
        'debe lanzar NotFoundException cuando el usuario no existe [en BD real]',
        () async {
      expect(
        () => authService.desactivarUsuario(-1),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('AuthService.obtenerUsuarioRegistrado con BD real', () {
    test(
        'debe obtener el primer usuario registrado cuando existe [en BD real]',
        () async {
      final email = _emailUnico();
      await _crearUsuario(email: email);

      final usuario = await authService.obtenerUsuarioRegistrado();

      expect(usuario, isNotNull);
      expect(usuario.esActivo, true);
    });
  });
}
