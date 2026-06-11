# Auth - Pruebas Unitarias

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +36: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 36 |
| Exitosas | 36 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| AuthService | 21 | 21 |
| AuthController | 9 | 9 |
| AuthService (HMAC) | 3 | 3 |
| DniEncryptor | 3 | 3 |

## 2. Tests Ejecutados

### 2.1. AuthService (21 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | iniciarSesion | debe retornar usuario cuando credenciales son validas | Happy Path |
| 2 | iniciarSesion | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 3 | registrar | debe crear usuario cuando email no existe | Happy Path |
| 4 | registrar | debe lanzar BusinessException cuando email ya registrado | Error Path |
| 5 | registrar | debe lanzar BusinessException cuando hay DatabaseException al crear | Error Path |
| 6 | obtenerUsuarioPorId | debe retornar usuario cuando existe | Happy Path |
| 7 | obtenerUsuarioPorId | debe lanzar BusinessException cuando usuario es null | Error Path |
| 8 | obtenerUsuarioPorId | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 9 | obtenerUsuarioPorEmail | debe retornar usuario cuando existe | Happy Path |
| 10 | obtenerUsuarioPorEmail | debe lanzar BusinessException cuando email no existe | Error Path |
| 11 | cambiarPin | debe actualizar PIN cuando los datos son correctos | Happy Path |
| 12 | cambiarPin | debe lanzar ValidationException cuando PIN nuevo no tiene 6 digitos | Validacion |
| 13 | cambiarPin | debe lanzar BusinessException cuando PIN actual es incorrecto | Error Path |
| 14 | obtenerUsuarioRegistrado | debe retornar el usuario registrado | Happy Path |
| 15 | recuperarPin | debe actualizar PIN cuando el nuevo PIN es valido | Happy Path |
| 16 | recuperarPin | debe lanzar ValidationException cuando PIN no tiene 6 digitos | Validacion |
| 17 | recuperarPin | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 18 | actualizarPerfil | debe actualizar el perfil correctamente | Happy Path |
| 19 | actualizarPerfil | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 20 | desactivarUsuario | debe desactivar el usuario correctamente | Happy Path |
| 21 | desactivarUsuario | debe lanzar BusinessException cuando hay DatabaseException | Error Path |

### 2.2. AuthController (9 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | iniciarSesion | delega al servicio | Delegacion |
| 2 | registrar | delega al servicio | Delegacion |
| 3 | obtenerUsuarioPorEmail | delega al servicio | Delegacion |
| 4 | obtenerUsuarioPorId | delega al servicio | Delegacion |
| 5 | obtenerUsuarioRegistrado | delega al servicio | Delegacion |
| 6 | cambiarPin | delega al servicio | Delegacion |
| 7 | recuperarPin | delega al servicio | Delegacion |
| 8 | actualizarPerfil | delega al servicio | Delegacion |
| 9 | desactivarUsuario | delega al servicio | Delegacion |

### 2.3. AuthService HMAC-SHA256 PIN (3 tests) — NUEVO

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | iniciarSesion | login usa PinEncryptor.hash para comparar PIN | Happy Path |
| 2 | iniciarSesion | login con PIN incorrecto lanza BusinessException | Error Path |
| 3 | PinEncryptor | mismo PIN produce consistentemente el mismo hash | Validacion |

### 2.4. DniEncryptor (3 tests) — NUEVO

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | encryptAES/decryptAES | ciclo completo | Happy Path |
| 2 | decryptAES | plaintext legacy retorna tal cual | Validacion |
| 3 | PinEncryptor | hash tiene 64 caracteres | Validacion |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path | Validaciones |
|---|---|---|---|
| iniciarSesion | si | si | si (HMAC-SHA256) |
| registrar | si | si | vacio |
| obtenerUsuarioPorId | si | si | vacio |
| obtenerUsuarioPorEmail | si | si | vacio |
| cambiarPin | si | si | si |
| obtenerUsuarioRegistrado | si | vacio | vacio |
| recuperarPin | si | si | si |
| actualizarPerfil | si | si | vacio |
| desactivarUsuario | si | si | vacio |

## 4. Cambios Aplicados (Sesion 11/jun/2026)

1. **PinEncryptor**: HMAC-SHA256 con `ENCRYPTION_KEY` reemplaza SHA-256 legacy. Sin fallback.
2. **DniEncryptor**: AES-256-CBC para DNI en BD. `decryptAES` tiene fallback para plaintext legacy (sin `:`).
3. **UsuarioRepository**: removida validacion de longitud de PIN en repositorio.
4. **Nuevo**: `auth_service_test.dart` (6 tests) — HMAC PIN login y ciclo DNI AES.

## 5. Conclusiones

AuthService y AuthController estan completamente probados con 36 tests. Se agrego cobertura de HMAC-SHA256 para PIN y AES-256-CBC para DNI. El nuevo flujo de autenticacion usa hashing determinista con clave secreta.
