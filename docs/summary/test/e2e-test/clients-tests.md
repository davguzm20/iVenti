# Clients - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
# clients_detail_test.dart (11 casos)
All tests passed!  (01:03)

# clients_list_test.dart (10 casos)
All tests passed!  (01:30)
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 2 (21 casos) |
| Exitosas | 2 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Estado |
|------|-------|--------|
| Flujo Completo | 2 | OK |

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
| Clientes en listado | Los clientes registrados aparecen en el listado principal | Happy Path | OK |
| Buscar por nombre | Se ingresa un nombre en el campo de busqueda. La lista se filtra mostrando solo los clientes coincidentes | Happy Path | OK |
| Limpiar busqueda | Se restaura el listado completo al limpiar el campo de busqueda | Happy Path | OK |
| Navegar a filtros | Se accede a la pantalla de filtros de clientes | Happy Path | OK |
| Activar filtro | Se activa el filtro de clientes. Aparecen las opciones "Deudores" y "Regulares" | Happy Path | OK |
| Seleccionar Deudores | Se selecciona el filtro "Deudores". El listado se actualiza mostrando solo clientes con deuda | Happy Path | OK |
| Aplicar filtros | Se confirma la aplicacion de los filtros seleccionados. El sistema retorna al listado filtrado | Happy Path | OK |
| Navegar a detalle | Se selecciona un cliente del listado. El sistema abre la pantalla de detalle del cliente | Happy Path | OK |
| Estado Deudor | La pantalla de detalle muestra la etiqueta "Estado: Deudor" para clientes con deuda pendiente | Happy Path | OK |
| Volver a lista | Se retrocede desde el detalle. El sistema retorna al listado de clientes | Happy Path | OK |

**Total casos: 10**

#### Clients Detail

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver cliente en listado | El cliente registrado aparece en el listado de clientes | Happy Path | OK |
| Navegar a detalle | Se selecciona un cliente del listado. El sistema abre la pantalla de detalle | Happy Path | OK |
| Ver DNI | El numero de DNI del cliente se muestra en la pantalla de detalle | Happy Path | OK |
| Ver estado Deudor | La pantalla de detalle muestra la etiqueta "DEUDOR" cuando el cliente tiene deuda pendiente | Happy Path | OK |
| Ver ventas | Las ventas asociadas al cliente se listan en la pantalla de detalle | Happy Path | OK |
| Boton pagar habilitado | El boton de pago se encuentra habilitado cuando el cliente es deudor | Happy Path | OK |
| Cancelar deuda: dialogo | Se abre el dialogo de cancelacion mostrando el monto pendiente del cliente | Happy Path | OK |
| Monto invalido (0) | Se ingresa un monto igual a cero. Aparece el mensaje de error correspondiente | Error Path | OK |
| Monto excedido | Se ingresa un monto superior a la deuda pendiente. Aparece el mensaje de error correspondiente | Error Path | OK |
| Pago exitoso | Se ingresa un monto valido y se confirma el pago. Aparece el dialogo de exito | Happy Path | OK |
| Volver a lista | Se confirma el pago. El sistema retorna al listado de clientes | Happy Path | OK |

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

Los 2 tests E2E de clientes (21 casos) pasan correctamente. Todos los flujos de listado, busqueda, filtros, detalle y pago de deuda estan cubiertos.
