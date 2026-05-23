import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/requests/LoginRequest.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';
import 'package:iventi/features/auth/services/AuthService.dart';
import 'package:iventi/features/auth/repositories/IUsuarioRepository.dart';

import '../../../mocks_mocks.dart';
import 'package:iventi/features/auth/enums/TipoRol.dart';

void main() {
  late MockIUsuarioRepository mockRepo;
  late AuthService authService;

  final usuarioValido = UsuarioEntity(
    idUsuario: 1,
    email: 'test@test.com',
    nombre: 'Test',
    pin: '123456',
    rol: TipoRol.ADMINISTRADOR,
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockIUsuarioRepository();
    authService = AuthService(mockRepo);
  });

  group('AuthService.iniciarSesion', () {
    test('debe retornar usuario cuando credenciales son validas', () async {
      when(mockRepo.validarCredenciales(any)).thenAnswer((_) async => usuarioValido);

      final result = await authService.iniciarSesion('test@test.com', '123456');

      expect(result, usuarioValido);
      verify(mockRepo.validarCredenciales(any)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.validarCredenciales(any)).thenThrow(DatabaseException('Error BD'));

      expect(
        () => authService.iniciarSesion('test@test.com', '123456'),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.registrar', () {
    test('debe crear usuario cuando email no existe', () async {
      when(mockRepo.obtenerUsuarioPorEmail(any)).thenAnswer((_) async => null);
      when(mockRepo.crearUsuario(any)).thenAnswer((_) async => usuarioValido);

      final request = CrearUsuarioRequest(
        email: 'nuevo@test.com',
        nombre: 'Nuevo',
        pin: '123456',
      );
      final result = await authService.registrar(request);

      expect(result, usuarioValido);
      verify(mockRepo.crearUsuario(request)).called(1);
    });

    test('debe lanzar BusinessException cuando email ya registrado', () async {
      when(mockRepo.obtenerUsuarioPorEmail(any)).thenAnswer((_) async => usuarioValido);

      final request = CrearUsuarioRequest(
        email: 'test@test.com',
        nombre: 'Test',
        pin: '123456',
      );

      expect(
        () => authService.registrar(request),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe lanzar BusinessException cuando hay DatabaseException al crear', () async {
      when(mockRepo.obtenerUsuarioPorEmail(any)).thenAnswer((_) async => null);
      when(mockRepo.crearUsuario(any)).thenThrow(DatabaseException('Error BD'));

      final request = CrearUsuarioRequest(
        email: 'nuevo@test.com',
        nombre: 'Nuevo',
        pin: '123456',
      );

      expect(
        () => authService.registrar(request),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.obtenerUsuarioPorId', () {
    test('debe retornar usuario cuando existe', () async {
      when(mockRepo.obtenerUsuarioPorId(1)).thenAnswer((_) async => usuarioValido);

      final result = await authService.obtenerUsuarioPorId(1);

      expect(result, usuarioValido);
    });

    test('debe lanzar BusinessException cuando usuario es null', () async {
      when(mockRepo.obtenerUsuarioPorId(999)).thenAnswer((_) async => null);

      expect(
        () => authService.obtenerUsuarioPorId(999),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.obtenerUsuarioPorId(1)).thenThrow(DatabaseException('Error BD'));

      expect(
        () => authService.obtenerUsuarioPorId(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.obtenerUsuarioPorEmail', () {
    test('debe retornar usuario cuando existe', () async {
      when(mockRepo.obtenerUsuarioPorEmail('test@test.com'))
          .thenAnswer((_) async => usuarioValido);

      final result = await authService.obtenerUsuarioPorEmail('test@test.com');

      expect(result, usuarioValido);
    });

    test('debe lanzar BusinessException cuando email no existe', () async {
      when(mockRepo.obtenerUsuarioPorEmail('no@existe.com'))
          .thenAnswer((_) async => null);

      expect(
        () => authService.obtenerUsuarioPorEmail('no@existe.com'),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.cambiarPin', () {
    test('debe actualizar PIN cuando los datos son correctos', () async {
      when(mockRepo.obtenerUsuarioPorId(1)).thenAnswer((_) async => usuarioValido);
      when(mockRepo.actualizarPIN(1, '654321')).thenAnswer((_) async => null);

      await authService.cambiarPin(1, '123456', '654321');

      verify(mockRepo.actualizarPIN(1, '654321')).called(1);
    });

    test('debe lanzar ValidationException cuando PIN nuevo no tiene 6 digitos', () async {
      expect(
        () => authService.cambiarPin(1, '123456', '123'),
        throwsA(isA<ValidationException>()),
      );
    });

    test('debe lanzar BusinessException cuando PIN actual es incorrecto', () async {
      when(mockRepo.obtenerUsuarioPorId(1)).thenAnswer((_) async => usuarioValido);

      expect(
        () => authService.cambiarPin(1, '000000', '654321'),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.obtenerUsuarioRegistrado', () {
    test('debe retornar el usuario registrado', () async {
      when(mockRepo.obtenerUsuarioRegistrado()).thenAnswer((_) async => usuarioValido);

      final result = await authService.obtenerUsuarioRegistrado();

      expect(result, usuarioValido);
    });
  });

  group('AuthService.recuperarPin', () {
    test('debe actualizar PIN cuando el nuevo PIN es valido', () async {
      when(mockRepo.actualizarPIN(1, '654321')).thenAnswer((_) async => null);

      await authService.recuperarPin(1, '654321');

      verify(mockRepo.actualizarPIN(1, '654321')).called(1);
    });

    test('debe lanzar ValidationException cuando PIN no tiene 6 digitos', () async {
      expect(
        () => authService.recuperarPin(1, '123'),
        throwsA(isA<ValidationException>()),
      );
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.actualizarPIN(1, '654321')).thenThrow(DatabaseException('Error BD'));

      expect(
        () => authService.recuperarPin(1, '654321'),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.actualizarPerfil', () {
    test('debe actualizar el perfil correctamente', () async {
      when(mockRepo.actualizarUsuario(1, nombre: 'Nuevo', email: anyNamed('email')))
          .thenAnswer((_) async => usuarioValido);

      final result = await authService.actualizarPerfil(1, nombre: 'Nuevo');

      expect(result, usuarioValido);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.actualizarUsuario(1, nombre: anyNamed('nombre'), email: anyNamed('email')))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => authService.actualizarPerfil(1, nombre: 'Nuevo'),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('AuthService.desactivarUsuario', () {
    test('debe desactivar el usuario correctamente', () async {
      when(mockRepo.desactivarUsuario(1)).thenAnswer((_) async => null);

      await authService.desactivarUsuario(1);

      verify(mockRepo.desactivarUsuario(1)).called(1);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockRepo.desactivarUsuario(1)).thenThrow(DatabaseException('Error BD'));

      expect(
        () => authService.desactivarUsuario(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });
}
