# Clients - Pruebas Unitarias

## 1. Resultados de Ejecucion

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
| ClienteService | 15 | 15 |
| ClienteController | 6 | 6 |
| ClienteEntity | 9 | 9 |

## 2. Tests Ejecutados

### 2.1. ClienteService (15 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearCliente | debe crear cliente correctamente | Happy Path |
| 2 | crearCliente | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 3 | actualizarCliente | debe actualizar cliente cuando existe | Happy Path |
| 4 | actualizarCliente | debe lanzar BusinessException cuando cliente no existe | Error Path |
| 5 | eliminarCliente | debe eliminar cliente cuando existe | Happy Path |
| 6 | eliminarCliente | debe lanzar BusinessException cuando cliente no existe | Error Path |
| 7 | obtenerClientePorId | debe retornar cliente cuando existe | Happy Path |
| 8 | obtenerClientePorId | debe retornar null cuando no existe | Happy Path |
| 9 | obtenerClientePorId | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 10 | buscarPorNombre | debe retornar lista de clientes | Happy Path |
| 11 | buscarPorNombre | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 12 | obtenerFiltrados | debe retornar clientes filtrados | Happy Path |
| 13 | obtenerFiltrados | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 14 | actualizarEstadoDeudor | debe actualizar estado deudor | Happy Path |
| 15 | actualizarEstadoDeudor | debe lanzar BusinessException cuando hay DatabaseException | Error Path |

### 2.2. ClienteController (6 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearCliente | delega a ClienteService | Delegacion |
| 2 | actualizarCliente | delega a ClienteService | Delegacion |
| 3 | eliminarCliente | delega a ClienteService | Delegacion |
| 4 | obtenerClientePorId | delega a ClienteService | Delegacion |
| 5 | buscarPorNombre | delega a ClienteService | Delegacion |
| 6 | obtenerFiltrados | delega a ClienteService | Delegacion |

### 2.3. ClienteEntity (9 tests) — NUEVO

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | constructor | debe crear con dni string | Happy Path |
| 2 | constructor | debe crear con dni null | Happy Path |
| 3 | constructor | debe crear solo con campos minimos requeridos | Happy Path |
| 4 | constructor | debe tener esDeudor false por default | Validacion |
| 5 | constructor | debe tener esActivo true por default | Validacion |
| 6 | constructor | debe crear con todos los campos | Happy Path |
| 7 | constructor | no debe tener campo apellidos | Validacion |
| 8 | constructor | no debe tener dniHash | Validacion |
| 9 | constructor | no debe tener dniMasked | Validacion |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| crearCliente | si | si | vacio |
| actualizarCliente | si | si | vacio |
| eliminarCliente | si | si | vacio |
| obtenerClientePorId | si | si | vacio |
| buscarPorNombre | si | si | vacio |
| obtenerFiltrados | si | si | vacio |
| actualizarEstadoDeudor | si | si | vacio |

### Entidad

| Metodo | Happy Path | Validaciones |
|--------|------------|--------------|
| constructor (dni) | si | si (null, campos legacy) |
| defaults (esDeudor, esActivo) | si | si |

## 4. Cambios Aplicados (Sesion 11/jun/2026)

1. **ClienteEntity**: campo `dni` reemplaza a `dniHash`/`dniMasked`. Sin `apellidos`. DNI se encripta con AES-256-CBC via `DniEncryptor`.
2. **ClienteMapper**: `fromMap` desencripta DNI con `decryptAES`, `toMap` encripta con `encryptAES`.
3. **Nuevo**: `cliente_entity_test.dart` (9 tests) — valida que la entidad no tenga campos legacy (`apellidos`, `dniHash`, `dniMasked`) y que los defaults sean correctos.

## 5. Conclusiones

ClienteService, ClienteController y ClienteEntity estan completamente probados. La entidad refleja el nuevo esquema con `dni` (AES) y sin campos legacy.

**Estado:** Completado - 30/30 tests aprobados (100%)
