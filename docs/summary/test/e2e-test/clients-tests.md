# Clients - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
[Codigo actualizado. Pendiente ajustar finders para ejecucion en emulador]
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 2 |
| Codigo actualizado | 2 |
| Pendiente finders | 2 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Estado |
|------|-------|--------|
| Flujo Completo | 2 | Codigo OK, pendiente finders |

## 2. Tests Ejecutados

### 2.1. Clients (2 tests)

| # | Flujo | Descripcion | Tipo |
|---|-------|-------------|------|
| 1 | Clients List | Listado, busqueda y filtros | Flujo Completo |
| 2 | Clients Detail | Detalle y pago de deuda | Flujo Completo |

### 2.2. Desglose de Casos por Flujo

#### Clients List

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Clientes en listado | Los clientes seed aparecen en la lista | Happy Path | Codigo OK, pendiente finders |
| Buscar por nombre | Se escribe nombre. La lista se filtra | Happy Path | Codigo OK, pendiente finders |
| Limpiar busqueda | Se toca X. Vuelven todos los clientes | Happy Path | Codigo OK, pendiente finders |
| Navegar a filtros | Se toca filter_list. Se abre FilterClientsPage | Happy Path | Codigo OK, pendiente finders |
| Activar filtro | Switch ON. Botones Deudores/Regulares aparecen | Happy Path | Codigo OK, pendiente finders |
| Seleccionar Deudores | Se toca "Deudores". Filtro activado | Happy Path | Codigo OK, pendiente finders |
| Aplicar filtros | Se toca "Aplicar Filtros". Se regresa a clients | Happy Path | Codigo OK, pendiente finders |
| Navegar a detalle | Se toca cliente. Se abre DetailsClientPage | Happy Path | Codigo OK, pendiente finders |
| Estado Deudor | El detalle muestra "Estado: Deudor" | Happy Path | Codigo OK, pendiente finders |
| Volver a lista | Se toca back. Se regresa a ClientsPage | Happy Path | Codigo OK, pendiente finders |

**Total casos: 10**

#### Clients Detail

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver cliente en listado | Cliente seed aparece en el listado | Happy Path | Codigo OK, pendiente finders |
| Navegar a detalle | Se toca cliente. Se abre detalle | Happy Path | Codigo OK, pendiente finders |
| Ver DNI | El DNI del cliente se muestra | Happy Path | Codigo OK, pendiente finders |
| Ver estado Deudor | "DEUDOR" en el detalle | Happy Path | Codigo OK, pendiente finders |
| Ver ventas | Ventas del cliente se listan | Happy Path | Codigo OK, pendiente finders |
| Boton pagar habilitado | attach_money activo por esDeudor=true | Happy Path | Codigo OK, pendiente finders |
| Cancelar deuda: dialogo | Se abre dialogo con monto pendiente | Happy Path | Codigo OK, pendiente finders |
| Monto invalido (0) | Se ingresa 0. ErrorDialog | Error Path | Codigo OK, pendiente finders |
| Monto excedido | Se ingresa > pendiente. ErrorDialog | Error Path | Codigo OK, pendiente finders |
| Pago exitoso | Se ingresa monto valido. SuccessDialog | Happy Path | Codigo OK, pendiente finders |
| Volver a lista | Ok en dialogo. Se regresa a lista | Happy Path | Codigo OK, pendiente finders |

**Total casos: 11**

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Clients List | si (login) | si | no | si |
| Clients Detail | si (login) | si | si | si |

## 4. Cambios Aplicados (Sesion 11/jun/2026)

1. **Esquema DB**: columna `apellidos` eliminada de `clientes`, `dni_hash` dropeado, solo queda `dni` (AES)
2. **PIN**: INSERT seed usa `PinEncryptor.hash('123456')`
3. **Auditoria**: `SET app.id_usuario = 1` antes de INSERTs raw
4. **device_registered**: `SharedPreferences.setBool('device_registered', true)` para saltar Welcome
5. **cleanTestData**: removido `OR apellidos LIKE 'e2e_%'`
6. **Texto esperado**: corregido de `'e2e_cliente detail'` a `'e2e_cliente'` (sin apellidos)

## 5. Conclusiones

Los 2 tests E2E de clientes tienen el codigo actualizado para el nuevo schema (sin `apellidos`, con `dni` AES, PIN HMAC-SHA256). Pendiente ajustar finders para ejecucion en emulador.
