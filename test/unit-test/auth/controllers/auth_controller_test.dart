import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:iventi/features/auth/entities/UsuarioEntity.dart';
import 'package:iventi/features/auth/dtos/requests/CrearUsuarioRequest.dart';
import 'package:iventi/features/auth/enums/TipoRol.dart';
import 'package:iventi/features/auth/services/AuthService.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';

import '../../../mocks_mocks.dart';

void main() {
  late MockAuthService mockService;
  late AuthController controller;

  final usuarioValido = UsuarioEntity(
    idUsuario: 1,
    email: 'test@test.com',
    nombre: 'Test',
    pin: '123456',
    rol: TipoRol.ADMINISTRADOR,
    creadoEn: DateTime(2024),
  );

  setUp(() {
    mockService = MockAuthService();
    controller = AuthController(mockService);
  });

  test('iniciarSesion delega al servicio', () async {
    when(mockService.iniciarSesion('a@b.com', '1234'))
        .thenAnswer((_) async => usuarioValido);

    final result = await controller.iniciarSesion('a@b.com', '1234');

    expect(result, usuarioValido);
    verify(mockService.iniciarSesion('a@b.com', '1234')).called(1);
  });

  test('registrar delega al servicio', () async {
    final request = CrearUsuarioRequest(email: 'a@b.com', nombre: 'A', pin: '123456');
    when(mockService.registrar(request)).thenAnswer((_) async => usuarioValido);

    final result = await controller.registrar(request);

    expect(result, usuarioValido);
    verify(mockService.registrar(request)).called(1);
  });

  test('obtenerUsuarioPorEmail delega al servicio', () async {
    when(mockService.obtenerUsuarioPorEmail('a@b.com'))
        .thenAnswer((_) async => usuarioValido);

    final result = await controller.obtenerUsuarioPorEmail('a@b.com');

    expect(result, usuarioValido);
    verify(mockService.obtenerUsuarioPorEmail('a@b.com')).called(1);
  });

  test('obtenerUsuarioPorId delega al servicio', () async {
    when(mockService.obtenerUsuarioPorId(1)).thenAnswer((_) async => usuarioValido);

    final result = await controller.obtenerUsuarioPorId(1);

    expect(result, usuarioValido);
    verify(mockService.obtenerUsuarioPorId(1)).called(1);
  });

  test('obtenerUsuarioRegistrado delega al servicio', () async {
    when(mockService.obtenerUsuarioRegistrado()).thenAnswer((_) async => usuarioValido);

    final result = await controller.obtenerUsuarioRegistrado();

    expect(result, usuarioValido);
    verify(mockService.obtenerUsuarioRegistrado()).called(1);
  });

  test('cambiarPin delega al servicio', () async {
    when(mockService.cambiarPin(1, '123456', '654321')).thenAnswer((_) async => null);

    await controller.cambiarPin(1, '123456', '654321');

    verify(mockService.cambiarPin(1, '123456', '654321')).called(1);
  });

  test('recuperarPin delega al servicio', () async {
    when(mockService.recuperarPin(1, '654321')).thenAnswer((_) async => null);

    await controller.recuperarPin(1, '654321');

    verify(mockService.recuperarPin(1, '654321')).called(1);
  });

  test('actualizarPerfil delega al servicio', () async {
    when(mockService.actualizarPerfil(1, nombre: 'Nuevo', email: anyNamed('email')))
        .thenAnswer((_) async => usuarioValido);

    final result = await controller.actualizarPerfil(1, nombre: 'Nuevo');

    expect(result, usuarioValido);
    verify(mockService.actualizarPerfil(1, nombre: 'Nuevo')).called(1);
  });

  test('desactivarUsuario delega al servicio', () async {
    when(mockService.desactivarUsuario(1)).thenAnswer((_) async => null);

    await controller.desactivarUsuario(1);

    verify(mockService.desactivarUsuario(1)).called(1);
  });
}
