# Estándares de Código - iVenti

## Filosofía

Español para dominio de negocio, inglés para infraestructura técnica.

## Convenciones de Nomenclatura

| Aspecto | Regla | Ejemplo |
|---|---|---|
| Archivos | `PascalCase.dart` | `VentaController.dart` |
| Clases de dominio | Español PascalCase | `VentaService`, `ClienteEntity` |
| Clases de infraestructura | Inglés PascalCase | `PostgresDatasource`, `ServiceLocator` |
| Métodos | Español camelCase | `obtenerVentas()`, `registrarPago()` |
| Variables | Español camelCase | `fechaInicio`, `montoTotal` |
| Campos privados | `_` + español camelCase | `_conexion`, `_cargarVentas()` |
| Enums | Tipo PascalCase, valores UPPER_SNAKE_CASE | `TipoRol.ADMINISTRADOR` |
| IDs | `Id` (no `ID` ni `id`) | `obtenerPorId()`, `idUsuario` |

## DTOs

- **Requests**: Verbo español + sustantivo español + sufijo `Request` → `CrearVentaRequest`
- **Responses**: Sustantivo español + sufijo `Response` → `VentaResponse`

## Imports

1. Paquetes externos primero (`flutter`, `go_router`, etc.)
2. Luego `package:iventi/...` agrupados por feature
3. Usar rutas absolutas, nunca relativas

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/features/ventas/controllers/VentaController.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
```

## SQL

Usar triple comilla simple `'''` para queries multilínea.

## Strings y Mensajes

- UI en español con tildes: `"Iniciar sesión"`
- Errores en español con tildes: `"La fecha de inicio no puede ser posterior"`
- Comentarios en español

## Estructura de Capas

```
Page → Controller → Service → Repository → PostgresDatasource
```

- **Controllers**: Delegación delgada, expuestos vía Provider
- **Services**: Lógica de negocio, validación, traducción de excepciones
- **Repositories**: Acceso a datos, queries SQL, mapeo a DTOs
- **Mappers**: Métodos estáticos `fromMap()`, `toMap()`, `fromResponse()`
- **Entities**: Campos `final`, IDs nullable (`int?`), named params con `required`

## Manejo de Errores

Jerarquía de excepciones:

```
AppException
  ├── BusinessException
  ├── ValidationException
  ├── AuthenticationException
  ├── NotFoundException
  ├── DatabaseException
  └── NetworkException
```

Patrón: capturar excepción de bajo nivel, lanzar excepción de alto nivel.

## Estado

- `ServiceLocator` como singleton estático para DI
- Controllers expuestos vía `Provider.value()`
- Estado de UI con `setState()` en `StatefulWidget`

## Encriptación

| Campo | Método | Clase | DB Column |
|-------|--------|-------|-----------|
| `usuarios.pin` | HMAC-SHA256 (hash) | `PinEncryptor.hash()` | `VARCHAR(64)` |
| `clientes.dni` | AES-256-CBC (cifrado reversible) | `DniEncryptor.encryptAES()` / `decryptAES()` | `VARCHAR(100)` |
| `ventas.codigo_boleta` | Secuencia PostgreSQL | `generar_codigo_boleta()` | `VARCHAR(20)` |

- `PinEncryptor.hash()` usa `ENCRYPTION_KEY` del `.env` como clave HMAC. Hash de 64 caracteres hex.
- `DniEncryptor` usa `ENCRYPTION_KEY` decodificado de base64 como clave AES-256. Cada encriptación usa IV aleatorio de 16 bytes. Formato: `IV:ciphered` (base64).
- `DniEncryptor.decryptAES()`: si el valor no contiene `:`, lo devuelve tal cual (compatibilidad legacy).

## Auditoría

- El trigger `auditar_general()` requiere `SET app.id_usuario` antes de INSERT/UPDATE/DELETE.
- En tests: `await conn.execute("SET app.id_usuario = '1'")` o `= '$testUserId'`.
- `cleanTestData()` en E2E incluye `SET app.id_usuario = 1` antes de los DELETE.
- En producción: `PostgresDatasource.connection` lo setea vía `ServiceLocator.usuarioActualId`.

## Tests E2E

- Insertar usuarios con `pin: PinEncryptor.hash('123456')`, nunca plaintext.
- Insertar clientes con `dni: DniEncryptor.encryptAES('XXXXXXXX')`.
- Usar `SharedPreferences.setBool('device_registered', true)` antes de `app.main()`.
- Usar `await conn.execute("SET app.id_usuario = 1")` después de obtener conexión.
- Scopear `EditableText` al `AlertDialog` o `AppBar` en vez de búsqueda global con `index: 0`.
