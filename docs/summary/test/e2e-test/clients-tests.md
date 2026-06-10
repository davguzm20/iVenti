# Clients - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
[PENDING - to be filled after execution]
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 2 |
| Exitosas | 0 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Flujo Completo | 2 | 0 |

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
| Clientes en listado | Los clientes seed aparecen en la lista | Happy Path | PENDING |
| Buscar por nombre | Se escribe nombre. La lista se filtra | Happy Path | PENDING |
| Limpiar busqueda | Se toca X. Vuelven todos los clientes | Happy Path | PENDING |
| Navegar a filtros | Se toca filter_list. Se abre FilterClientsPage | Happy Path | PENDING |
| Activar filtro | Switch ON. Botones Deudores/Regulares aparecen | Happy Path | PENDING |
| Seleccionar Deudores | Se toca "Deudores". Filtro activado | Happy Path | PENDING |
| Aplicar filtros | Se toca "Aplicar Filtros". Se regresa a clients | Happy Path | PENDING |
| Navegar a detalle | Se toca cliente. Se abre DetailsClientPage | Happy Path | PENDING |
| Estado Deudor | El detalle muestra "Estado: Deudor" | Happy Path | PENDING |
| Volver a lista | Se toca back. Se regresa a ClientsPage | Happy Path | PENDING |

**Total casos: 10**

#### Clients Detail

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver cliente en listado | Cliente seed aparece en el listado | Happy Path | PENDING |
| Navegar a detalle | Se toca cliente. Se abre detalle | Happy Path | PENDING |
| Ver DNI | El DNI del cliente se muestra | Happy Path | PENDING |
| Ver estado Deudor | "Estado: Deudor" en rojo | Happy Path | PENDING |
| Ver ventas | Ventas del cliente se listan | Happy Path | PENDING |
| Boton pagar habilitado | attach_money activo por esDeudor=true | Happy Path | PENDING |
| Cancelar deuda: dialogo | Se abre dialogo con monto pendiente | Happy Path | PENDING |
| Monto invalido (0) | Se ingresa 0. ErrorDialog | Error Path | PENDING |
| Monto excedido | Se ingresa > pendiente. ErrorDialog | Error Path | PENDING |
| Pago exitoso | Se ingresa monto valido. SuccessDialog | Happy Path | PENDING |
| Volver a lista | Ok en dialogo. Se regresa a lista | Happy Path | PENDING |

**Total casos: 11**

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Clients List | si (login) | si | no | si |
| Clients Detail | si (login) | si | si | si |

## 4. Interpretacion

Se cubre el flujo completo de clientes: listado con busqueda y filtros por estado de deuda, detalle de cliente con ventas asociadas, y pago de deuda con validaciones de monto. Los tests requieren seed de clientes, usuario y ventas credito con saldo pendiente.

## 5. Conclusiones

[PENDING - to be filled after execution]
