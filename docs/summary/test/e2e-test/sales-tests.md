# Sales - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
[Parcial - fixes estructurales aplicados. Pendiente ejecucion completa en emulador]
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 4 (51 casos) |
| Fixes aplicados | 4 |
| Pendientes ejecucion | 4 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Estado |
|------|-------|--------|
| Flujo Completo | 4 | Fixes OK, pendiente E2E |

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
| Empty state "No se encontraron ventas" | La pagina de ventas se carga sin datos | Happy Path | PENDING |
| Navegar a crear venta | Se toca +. Se abre CreateSalePage | Happy Path | PENDING |
| Confirmar sin productos | Se toca Confirmar con el carrito vacio. Aparece ErrorDialog "Sin productos" | Error Path | PENDING |
| Abrir dialogo agregar producto | Se toca "Agregar producto". Se abre el dialog de busqueda | Happy Path | PENDING |
| Buscar producto por nombre | Se escribe el nombre del producto. Aparece en resultados | Happy Path | PENDING |
| Cancelar dialogo sin agregar | Se toca Cancelar en el dialogo. Vuelve sin cambios | Error Path | PENDING |
| Seleccionar producto y cargar lote | Se toca el producto. Aparece info del lote | Happy Path | PENDING |
| Agregar producto al carrito | Se toca "Agregar". El producto aparece en el carrito | Happy Path | PENDING |
| Eliminar producto del carrito | Se toca el icono delete. El producto se elimina | Error Path | PENDING |
| Re-agregar producto | Se agrega producto nuevamente para continuar flujo | Happy Path | PENDING |
| Confirmar venta y navegar a pago | Se toca Confirmar. Navega a PaymentPage | Happy Path | PENDING |
| Monto insuficiente | Se ingresa monto menor al total. Aparece ErrorDialog "Monto insuficiente" | Error Path | PENDING |
| Ingresar monto correcto | Se ingresa el monto exacto en "Cantidad recibida" | Happy Path | PENDING |
| Confirmar pago exitoso | Se toca Confirmar. Aparece SuccessDialog "Venta registrada" | Happy Path | PENDING |
| Regresar a SalesPage | Se toca Ok. Navega a SalesPage con replace | Happy Path | PENDING |
| Ver venta en el listado | La venta creada aparece en el listado | Happy Path | PENDING |
| Error de API al cargar ventas | Fallo en la API. ErrorDialog "No se pudieron cargar las ventas" | Error Path | PENDING |

**Total casos: 17**

#### Sales Credito

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Crear venta y navegar a pago | Se agrega producto y se confirma. Navega a PaymentPage | Happy Path | PENDING |
| Toggle a Credito | Se selecciona "Credito" en lugar de "Al contado" | Happy Path | PENDING |
| Confirmar sin cliente | Se confirma en credito sin seleccionar cliente. ErrorDialog "Cliente requerido" | Error Path | PENDING |
| Toggle "Crear Cliente" sin nombre | Se activa crear cliente y se confirma sin nombre. ErrorDialog "Campos incompletos" | Error Path | PENDING |
| Llenar datos de nuevo cliente | Se ingresa nombre del nuevo cliente | Happy Path | PENDING |
| Ingresar monto parcial | Se ingresa monto parcial para credito | Happy Path | PENDING |
| Confirmar credito exitoso | Se confirma pago. Aparece SuccessDialog "Venta registrada" | Happy Path | PENDING |
| Regresar a SalesPage | Se toca Ok. Navega a SalesPage con replace | Happy Path | PENDING |

**Total casos: 8**

#### Sales List

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver venta en listado | Venta seed aparece en el listado | Happy Path | PENDING |
| Buscar icono toggle | El icono de busqueda abre y cierra el campo | Happy Path | PENDING |
| Cerrar busqueda | Se toca X. El campo de busqueda se cierra | Happy Path | PENDING |
| Navegar a filtros | Se toca filter_list. Se abre FilterSalesPage | Happy Path | PENDING |
| Activar filtro tipo pago "Al contado" | Se activa switch y se selecciona "Al contado" | Happy Path | PENDING |
| Cambiar a "Credito" | Se selecciona "Credito" en lugar de "Al contado" | Happy Path | PENDING |
| Activar filtro por fecha | Se activa switch de fecha. testFechaFija simula date picker | Happy Path | PENDING |
| Toggle fecha off resetea | Se desactiva switch de fecha. Los valores se limpian | Error Path | PENDING |
| Aplicar filtros | Se toca "Aplicar Filtros". Se regresa a SalesPage con filtros | Happy Path | PENDING |
| Back desde filtros sin aplicar | Se retrocede con arrow_back. No se aplican filtros | Error Path | PENDING |

**Total casos: 10**

#### Sales Detail

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver venta credito en listado | La venta credito aparece en el listado | Happy Path | PENDING |
| Navegar a detalle | Se toca la venta. Se abre DetailsSalePage | Happy Path | PENDING |
| Ver datos de venta | Se muestran monto total, cancelado y tipo | Happy Path | PENDING |
| Generar PDF desde print | Se toca print. Se genera PDF y abre visor | Happy Path | PENDING |
| Compartir PDF | Se toca share en el visor. Se abre share sheet | Happy Path | PENDING |
| Volver del visor | Se toca back. Se regresa a DetailsSalePage | Happy Path | PENDING |
| Abrir dialogo cancelar deuda | Se toca attach_money. Aparece dialogo "Cancelar deuda" | Happy Path | PENDING |
| Monto invalido (0) | Se ingresa monto 0. ErrorDialog "Monto invalido" | Error Path | PENDING |
| Monto excedido | Se ingresa monto > pendiente. ErrorDialog "Monto excedido" | Error Path | PENDING |
| Monto valido y pago exitoso | Se ingresa monto pendiente. SuccessDialog "Pago registrado" | Happy Path | PENDING |
| Anular venta | Se toca block. ConfirmDialog. Se confirma anulacion | Happy Path | PENDING |
| Regresar a SalesPage | Despues de anular, se regresa a SalesPage | Happy Path | PENDING |
| Error de API al cargar detalle | Fallo en la API. ErrorDialog "No se pudieron obtener los datos" | Error Path | PENDING |

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

Los 4 tests E2E de ventas tienen sus fixes de schema y autenticacion aplicados. Los INSERTs seed son compatibles con el nuevo esquema (sin apellidos, con codigo_boleta, PIN HMAC-SHA256). Pendiente ejecucion completa en emulador para verificar flujos de UI.
