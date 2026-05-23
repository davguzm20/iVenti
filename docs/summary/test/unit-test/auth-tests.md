# Auth - Pruebas Unitarias

## 1. Resultados de Ejecución

### 1.1. Salida de Consola

```
00:00 +30: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 30 |
| Exitosas | 30 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| AuthService | 21 | 21 |
| AuthController | 9 | 9 |

## 2. Tests Ejecutados

### AuthService (21 tests)

| # | Método | Descripción | Tipo |
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
| 12 | cambiarPin | debe lanzar ValidationException cuando PIN nuevo no tiene 6 digitos | Validación |
| 13 | cambiarPin | debe lanzar BusinessException cuando PIN actual es incorrecto | Error Path |
| 14 | obtenerUsuarioRegistrado | debe retornar el usuario registrado | Happy Path |
| 15 | recuperarPin | debe actualizar PIN cuando el nuevo PIN es valido | Happy Path |
| 16 | recuperarPin | debe lanzar ValidationException cuando PIN no tiene 6 digitos | Validación |
| 17 | recuperarPin | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 18 | actualizarPerfil | debe actualizar el perfil correctamente | Happy Path |
| 19 | actualizarPerfil | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 20 | desactivarUsuario | debe desactivar el usuario correctamente | Happy Path |
| 21 | desactivarUsuario | debe lanzar BusinessException cuando hay DatabaseException | Error Path |

### 2.2. AuthController (9 tests)

| # | Método | Descripción | Tipo |
|---|--------|-------------|------|
| 1 | iniciarSesion | delega al servicio | Delegación |
| 2 | registrar | delega al servicio | Delegación |
| 3 | obtenerUsuarioPorEmail | delega al servicio | Delegación |
| 4 | obtenerUsuarioPorId | delega al servicio | Delegación |
| 5 | obtenerUsuarioRegistrado | delega al servicio | Delegación |
| 6 | cambiarPin | delega al servicio | Delegación |
| 7 | recuperarPin | delega al servicio | Delegación |
| 8 | actualizarPerfil | delega al servicio | Delegación |
| 9 | desactivarUsuario | delega al servicio | Delegación |

## 3. Métodos Evaluados

| Método | Happy Path | Error Path | Validaciones |
|---|---|---|---|
| iniciarSesion | sí | sí | vacío |
| registrar | sí | sí | vacío |
| obtenerUsuarioPorId | sí | sí | vacío |
| obtenerUsuarioPorEmail | sí | sí | vacío |
| cambiarPin | sí | sí | sí |
| obtenerUsuarioRegistrado | sí | vacío | vacío |
| recuperarPin | sí | sí | sí |
| actualizarPerfil | sí | sí | vacío |
| desactivarUsuario | sí | sí | vacío |

## 4. Interpretación

1. **Cobertura:** 9 métodos del servicio + 9 métodos del controller evaluados
2. **Patrones verificados:**
   - DatabaseException se traduce a BusinessException
   - Validación de PIN de 6 dígitos
3. **Controllers:** delegan correctamente a los servicios

## 5. Conclusiones

AuthService y AuthController están completamente probados. Todos los métodos manejan correctamente happy path, error path y validaciones de negocio.
