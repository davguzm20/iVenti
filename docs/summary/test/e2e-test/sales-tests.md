# Sales - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
[Codigo actualizado. Pendiente ajustar finders para ejecucion en emulador]
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 4 (51 casos) |
| Codigo actualizado | 4 |
| Pendiente finders | 4 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Estado |
|------|-------|--------|
| Flujo Completo | 4 | Codigo OK, pendiente finders |

## 2. Tests Ejecutados

### 2.1. Sales (4 tests - 51 casos)

| # | Flujo | Descripcion | Tipo |
|---|-------|-------------|------|
| 1 | Sales Create | Creacion de venta y pago contado | Flujo Completo |
| 2 | Sales Credito | Creacion de venta a credito con cliente | Flujo Completo |
| 3 | Sales List | Listado, busqueda y filtros | Flujo Completo |
| 4 | Sales Detail | Detalle, pago parcial, anular y PDF | Flujo Completo |

### 2.2. Desglose de Casos por Flujo

#### Sales Create

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Empty state "No se encontraron ventas" | La pagina de ventas se carga sin datos | Happy Path | Codigo OK, pendiente finders |
| Navegar a crear venta | Se toca +. Se abre CreateSalePage | Happy Path | Codigo OK, pendiente finders |
| Confirmar sin productos | Se toca Confirmar con el carrito vacio. Aparece ErrorDialog "Sin productos" | Error Path | Codigo OK, pendiente finders |
| Abrir dialogo agregar producto | Se toca "Agregar producto". Se abre el dialog de busqueda | Happy Path | Codigo OK, pendiente finders |
| Buscar producto por nombre | Se escribe el nombre del producto. Aparece en resultados | Happy Path | Codigo OK, pendiente finders |
| Cancelar dialogo sin agregar | Se toca Cancelar en el dialogo. Vuelve sin cambios | Error Path | Codigo OK, pendiente finders |
| Seleccionar producto y cargar lote | Se toca el producto. Aparece info del lote | Happy Path | Codigo OK, pendiente finders |
| Agregar producto al carrito | Se toca "Agregar". El producto aparece en el carrito | Happy Path | Codigo OK, pendiente finders |
| Eliminar producto del carrito | Se toca el icono delete. El producto se elimina | Error Path | Codigo OK, pendiente finders |
| Re-agregar producto | Se agrega producto nuevamente para continuar flujo | Happy Path | Codigo OK, pendiente finders |
| Confirmar venta y navegar a pago | Se toca Confirmar. Navega a PaymentPage | Happy Path | Codigo OK, pendiente finders |
| Monto insuficiente | Se ingresa monto menor al total. Aparece ErrorDialog "Monto insuficiente" | Error Path | Codigo OK, pendiente finders |
| Ingresar monto correcto | Se ingresa el monto exacto en "Cantidad recibida" | Happy Path | Codigo OK, pendiente finders |
| Confirmar pago exitoso | Se toca Confirmar. Aparece SuccessDialog "Venta registrada" | Happy Path | Codigo OK, pendiente finders |
| Regresar a SalesPage | Se toca Ok. Navega a SalesPage con replace | Happy Path | Codigo OK, pendiente finders |
| Ver venta en el listado | La venta creada aparece en el listado | Happy Path | Codigo OK, pendiente finders |
| Error de API al cargar ventas | Fallo en la API. ErrorDialog "No se pudieron cargar las ventas" | Error Path | Codigo OK, pendiente finders |

**Total casos: 17**

#### Sales Credito

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Crear venta y navegar a pago | Se agrega producto y se confirma. Navega a PaymentPage | Happy Path | Codigo OK, pendiente finders |
| Toggle a Credito | Se selecciona "Credito" en lugar de "Al contado" | Happy Path | Codigo OK, pendiente finders |
| Confirmar sin cliente | Se confirma en credito sin seleccionar cliente. ErrorDialog "Cliente requerido" | Error Path | Codigo OK, pendiente finders |
| Toggle "Crear Cliente" sin nombre | Se activa crear cliente y se confirma sin nombre. ErrorDialog "Campos incompletos" | Error Path | Codigo OK, pendiente finders |
| Llenar datos de nuevo cliente | Se ingresa nombre del nuevo cliente | Happy Path | Codigo OK, pendiente finders |
| Ingresar monto parcial | Se ingresa monto parcial para credito | Happy Path | Codigo OK, pendiente finders |
| Confirmar credito exitoso | Se confirma pago. Aparece SuccessDialog "Venta registrada" | Happy Path | Codigo OK, pendiente finders |
| Regresar a SalesPage | Se toca Ok. Navega a SalesPage con replace | Happy Path | Codigo OK, pendiente finders |

**Total casos: 8**

#### Sales List

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver venta en listado | Venta seed aparece en el listado | Happy Path | Codigo OK, pendiente finders |
| Buscar icono toggle | El icono de busqueda abre y cierra el campo | Happy Path | Codigo OK, pendiente finders |
| Cerrar busqueda | Se toca X. El campo de busqueda se cierra | Happy Path | Codigo OK, pendiente finders |
| Navegar a filtros | Se toca filter_list. Se abre FilterSalesPage | Happy Path | Codigo OK, pendiente finders |
| Activar filtro tipo pago "Al contado" | Se activa switch y se selecciona "Al contado" | Happy Path | Codigo OK, pendiente finders |
| Cambiar a "Credito" | Se selecciona "Credito" en lugar de "Al contado" | Happy Path | Codigo OK, pendiente finders |
| Activar filtro por fecha | Se activa switch de fecha. testFechaFija simula date picker | Happy Path | Codigo OK, pendiente finders |
| Toggle fecha off resetea | Se desactiva switch de fecha. Los valores se limpian | Error Path | Codigo OK, pendiente finders |
| Aplicar filtros | Se toca "Aplicar Filtros". Se regresa a SalesPage con filtros | Happy Path | Codigo OK, pendiente finders |
| Back desde filtros sin aplicar | Se retrocede con arrow_back. No se aplican filtros | Error Path | Codigo OK, pendiente finders |

**Total casos: 10**

#### Sales Detail

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver venta credito en listado | La venta credito aparece en el listado | Happy Path | Codigo OK, pendiente finders |
| Navegar a detalle | Se toca la venta. Se abre DetailsSalePage | Happy Path | Codigo OK, pendiente finders |
| Ver datos de venta | Se muestran monto total, cancelado y tipo | Happy Path | Codigo OK, pendiente finders |
| Generar PDF desde print | Se toca print. Se genera PDF y abre visor | Happy Path | Codigo OK, pendiente finders |
| Compartir PDF | Se toca share en el visor. Se abre share sheet | Happy Path | Codigo OK, pendiente finders |
| Volver del visor | Se toca back. Se regresa a DetailsSalePage | Happy Path | Codigo OK, pendiente finders |
| Abrir dialogo cancelar deuda | Se toca attach_money. Aparece dialogo "Cancelar deuda" | Happy Path | Codigo OK, pendiente finders |
| Monto invalido (0) | Se ingresa monto 0. ErrorDialog "Monto invalido" | Error Path | Codigo OK, pendiente finders |
| Monto excedido | Se ingresa monto > pendiente. ErrorDialog "Monto excedido" | Error Path | Codigo OK, pendiente finders |
| Monto valido y pago exitoso | Se ingresa monto pendiente. SuccessDialog "Pago registrado" | Happy Path | Codigo OK, pendiente finders |
| Anular venta | Se toca block. ConfirmDialog. Se confirma anulacion | Happy Path | Codigo OK, pendiente finders |
| Regresar a SalesPage | Despues de anular, se regresa a SalesPage | Happy Path | Codigo OK, pendiente finders |
| Error de API al cargar detalle | Fallo en la API. ErrorDialog "No se pudieron obtener los datos" | Error Path | Codigo OK, pendiente finders |

**Total casos: 13**

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Sales Create | si (login) | si | si | si |
| Sales Credito | si (login) | si | si | si |
| Sales List | si (login) | si | no | si |
| Sales Detail | si (login) | si | si | si |

## 4. Cambios Aplicados (Sesion 11/jun/2026)

1. **Esquema DB**: columna `apellidos` eliminada de `clientes`, `codigo_boleta` agregado en `ventas`, `pin VARCHAR(64)` para HMAC-SHA256
2. **PIN**: todos los INSERT seed usan `PinEncryptor.hash('123456')` en vez de plaintext
3. **Auditoria**: `SET app.id_usuario = 1` antes de INSERTs raw para evitar null en trigger `auditar_general()`
4. **device_registered**: `SharedPreferences.setBool('device_registered', true)` para saltar Welcome en fresh install
5. **cleanTestData**: removido `OR apellidos LIKE 'e2e_%'` del DELETE de clientes

## 5. Conclusiones

Los 4 tests E2E de ventas tienen el codigo actualizado para el nuevo schema (sin apellidos, con codigo_boleta, PIN HMAC-SHA256). Pendiente ajustar finders para ejecucion en emulador.
