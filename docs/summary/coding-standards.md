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
