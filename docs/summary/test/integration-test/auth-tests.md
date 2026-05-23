# Auth - Pruebas de Integracion

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: loading test/integration-test/auth/auth_integration_test.dart
00:00 +0: (setUpAll)
00:02 +1: AuthService.registrar con BD real debe crear un usuario correctamente cuando los datos son validos [en BD real]
00:03 +2: AuthService.registrar con BD real debe lanzar BusinessException cuando el email ya esta registrado [en BD real]
00:05 +3: AuthService.iniciarSesion con BD real debe iniciar sesion correctamente cuando las credenciales son validas [en BD real]
00:06 +4: AuthService.iniciarSesion con BD real debe lanzar AuthenticationException cuando el email no existe [en BD real]
00:08 +5: AuthService.iniciarSesion con BD real debe lanzar AuthenticationException cuando el PIN es incorrecto [en BD real]
00:09 +6: AuthService.obtenerUsuarioPorId con BD real debe obtener un usuario por ID cuando existe [en BD real]
00:10 +7: AuthService.obtenerUsuarioPorId con BD real debe lanzar BusinessException cuando el ID no existe [en BD real]
00:12 +8: AuthService.obtenerUsuarioPorEmail con BD real debe obtener un usuario por email cuando existe [en BD real]
00:13 +9: AuthService.obtenerUsuarioPorEmail con BD real debe lanzar BusinessException cuando el email no existe [en BD real]
00:15 +10: AuthService.cambiarPin con BD real debe cambiar el PIN correctamente cuando el PIN actual es correcto [en BD real]
00:17 +11: AuthService.cambiarPin con BD real debe lanzar BusinessException cuando el PIN actual es incorrecto [en BD real]
00:19 +12: AuthService.recuperarPin con BD real debe recuperar el PIN correctamente [en BD real]
00:21 +13: AuthService.recuperarPin con BD real debe lanzar ValidationException cuando el nuevo PIN no tiene 6 digitos [en BD real]
00:22 +14: AuthService.actualizarPerfil con BD real debe actualizar el perfil correctamente [en BD real]
00:24 +15: AuthService.desactivarUsuario con BD real debe desactivar un usuario correctamente [en BD real]
00:25 +16: AuthService.desactivarUsuario con BD real debe lanzar NotFoundException cuando el usuario no existe [en BD real]
00:27 +17: AuthService.obtenerUsuarioRegistrado con BD real debe obtener el primer usuario registrado cuando existe [en BD real]
00:27 +17: (tearDownAll)
00:27 +17: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 17 |
| Exitosas | 17 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Registro | 2 | 2 |
| Autenticacion | 3 | 3 |
| Consulta | 4 | 4 |
| Actualizacion | 4 | 4 |
| Desactivacion | 2 | 2 |
| Recuperacion | 2 | 2 |

## 2. Tests Ejecutados

### 2.1. AuthService (17 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | registrar | Crear usuario correctamente con datos validos | Registro |
| 2 | registrar | Lanzar BusinessException cuando el email ya esta registrado | Registro |
| 3 | iniciarSesion | Iniciar sesion correctamente con credenciales validas | Autenticacion |
| 4 | iniciarSesion | Lanzar AuthenticationException cuando el email no existe | Autenticacion |
| 5 | iniciarSesion | Lanzar AuthenticationException cuando el PIN es incorrecto | Autenticacion |
| 6 | obtenerUsuarioPorId | Obtener usuario por ID cuando existe | Consulta |
| 7 | obtenerUsuarioPorId | Lanzar BusinessException cuando el ID no existe | Consulta |
| 8 | obtenerUsuarioPorEmail | Obtener usuario por email cuando existe | Consulta |
| 9 | obtenerUsuarioPorEmail | Lanzar BusinessException cuando el email no existe | Consulta |
| 10 | cambiarPin | Cambiar el PIN correctamente cuando el actual es correcto | Actualizacion |
| 11 | cambiarPin | Lanzar BusinessException cuando el PIN actual es incorrecto | Actualizacion |
| 12 | recuperarPin | Recuperar el PIN correctamente | Actualizacion |
| 13 | recuperarPin | Lanzar ValidationException cuando el nuevo PIN no tiene 6 digitos | Actualizacion |
| 14 | actualizarPerfil | Actualizar el perfil correctamente | Actualizacion |
| 15 | desactivarUsuario | Desactivar un usuario correctamente | Desactivacion |
| 16 | desactivarUsuario | Lanzar NotFoundException cuando el usuario no existe | Desactivacion |
| 17 | obtenerUsuarioRegistrado | Obtener el primer usuario registrado cuando existe | Recuperacion |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| registrar | si | si | no |
| iniciarSesion | si | si | no |
| obtenerUsuarioPorId | si | si | no |
| obtenerUsuarioPorEmail | si | si | no |
| cambiarPin | si | si | no |
| recuperarPin | si | no | si |
| actualizarPerfil | si | no | no |
| desactivarUsuario | si | si | no |
| obtenerUsuarioRegistrado | si | no | no |

## 4. Interpretacion

- **Cobertura total:** 17 tests sobre 9 metodos de AuthService, cubriendo happy path y error path en la mayoria de casos.
- **Patron verificado:** Flujo completo Service, Repository, PostgreSQL real (Neon rama test) sin mocks en ninguna capa.
- **Base de datos real:** Los tests se ejecutan contra una instancia de Neon dedicada, validando consultas SQL reales, restricciones UNIQUE, y manejo de transacciones.
- **Limpieza:** Cada test se envuelve en BEGIN/ROLLBACK, los datos creados nunca persisten en la base de datos.
- **Controladores:** No se incluyen tests de AuthController ya que los controllers son capas de delegacion fina sin logica de base de datos propia.

## 5. Conclusiones

El modulo Auth funciona correctamente contra la base de datos real. Todos los flujos CRUD, autenticacion y manejo de errores se comportan segun lo esperado. Se valido que las restricciones UNIQUE del schema (email) se aplican correctamente desde la base de datos, y que las excepciones personalizadas (AuthenticationException, BusinessException, ValidationException, NotFoundException) se propagan adecuadamente desde el repository hacia el service.
