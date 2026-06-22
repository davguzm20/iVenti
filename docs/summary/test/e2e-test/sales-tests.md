# Sales - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
# sales_create_test.dart (17 casos)
All tests passed!  (01:26)

# sales_credito_test.dart (8 casos)
All tests passed!  (01:02)

# sales_list_test.dart (10 casos)
All tests passed!  (01:16)

# sales_detail_test.dart (13 casos)
All tests passed!  (01:53)

# sales_search_boleta_test.dart (7 casos)
All tests passed!  (01:03)

# sales_credito_existing_client_test.dart (10 casos)
All tests passed!  (01:01)
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 6 (65 casos) |
| Exitosas | 6 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Estado |
|------|-------|--------|
| Flujo Completo | 6 | OK |

## 2. Tests Ejecutados

### 2.1. Sales (6 tests - 65 casos)

| # | Flujo | Descripcion | Tipo |
|---|-------|-------------|------|
| 1 | Sales Create | Creacion de venta y pago contado | Flujo Completo |
| 2 | Sales Credito | Creacion de venta a credito con nuevo cliente | Flujo Completo |
| 3 | Sales List | Listado, busqueda y filtros | Flujo Completo |
| 4 | Sales Detail | Detalle, pago parcial, anular y PDF | Flujo Completo |
| 5 | Sales Search Boleta | Buscar venta por codigo_boleta | Flujo Completo |
| 6 | Sales Credito Existing | Credito con cliente existente (buscar cliente) | Flujo Completo |

### 2.2. Desglose de Casos por Flujo

#### Sales Create

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Empty state "No se encontraron ventas" | La pagina de ventas se carga sin ventas registradas. Aparece el mensaje de listado vacio | Happy Path | OK |
| Navegar a crear venta | Se accede a la pantalla de creacion de venta desde el menu principal | Happy Path | OK |
| Confirmar sin productos | Se intenta confirmar la venta con el carrito vacio. Aparece el mensaje de error "Sin productos" | Error Path | OK |
| Abrir dialogo agregar producto | Se abre el dialogo de busqueda de productos para agregar al carrito | Happy Path | OK |
| Buscar producto por nombre | Se ingresa el nombre del producto en el campo de busqueda. El producto aparece en los resultados | Happy Path | OK |
| Cancelar dialogo sin agregar | Se cancela el dialogo de busqueda sin seleccionar ningun producto. No se realizan cambios en el carrito | Error Path | OK |
| Seleccionar producto y cargar lote | Se selecciona un producto de los resultados. La informacion del lote se muestra en pantalla | Happy Path | OK |
| Agregar producto al carrito | Se confirma la agregacion del producto seleccionado. El producto aparece en el carrito de compras | Happy Path | OK |
| Eliminar producto del carrito | Se elimina un producto del carrito. El producto desaparece del listado del carrito | Error Path | OK |
| Re-agregar producto | Se agrega nuevamente un producto al carrito para continuar con el flujo de compra | Happy Path | OK |
| Confirmar venta y navegar a pago | Se confirma la venta con productos en el carrito. El sistema navega a la pantalla de pago | Happy Path | OK |
| Monto insuficiente | Se ingresa un monto menor al total de la venta. Aparece el mensaje de error "Monto insuficiente" | Error Path | OK |
| Ingresar monto correcto | Se ingresa el monto exacto en el campo "Cantidad recibida" | Happy Path | OK |
| Confirmar pago exitoso | Se confirma el pago con el monto correcto. Aparece el dialogo de exito "Venta registrada" | Happy Path | OK |
| Regresar a SalesPage | Se confirma el dialogo de exito. El sistema navega a la pantalla principal de ventas | Happy Path | OK |
| Ver venta en el listado | La venta creada aparece en el listado de ventas | Happy Path | OK |
| Error de API al cargar ventas | Ocurre un error en la API al cargar las ventas. Aparece el mensaje de error correspondiente | Error Path | OK |

**Total casos: 17**

#### Sales Credito

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Crear venta y navegar a pago | Se agrega un producto al carrito y se confirma la venta. El sistema navega a la pantalla de pago | Happy Path | OK |
| Toggle a Credito | Se selecciona el tipo de pago "Credito" en lugar de "Al contado" | Happy Path | OK |
| Confirmar sin cliente | Se confirma la venta a credito sin seleccionar un cliente. Aparece el mensaje de error "Cliente requerido" | Error Path | OK |
| Toggle "Crear Cliente" sin nombre | Se activa la opcion de crear un nuevo cliente y se confirma sin ingresar nombre. Aparece el mensaje de error "Campos incompletos" | Error Path | OK |
| Llenar datos de nuevo cliente | Se ingresan los datos del nuevo cliente en los campos correspondientes | Happy Path | OK |
| Ingresar monto parcial | Se ingresa un monto parcial como abono para la venta a credito | Happy Path | OK |
| Confirmar credito exitoso | Se confirma el pago del credito. Aparece el dialogo de exito "Venta registrada" | Happy Path | OK |
| Regresar a SalesPage | Se confirma el dialogo de exito. El sistema navega a la pantalla principal de ventas | Happy Path | OK |

**Total casos: 8**

#### Sales List

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver venta en listado | La venta de prueba aparece en el listado de ventas | Happy Path | OK |
| Buscar icono toggle | Se activa y desactiva el campo de busqueda de ventas | Happy Path | OK |
| Cerrar busqueda | Se desactiva la busqueda. El campo de texto se oculta y el listado se restaura | Happy Path | OK |
| Navegar a filtros | Se accede a la pantalla de filtros de ventas | Happy Path | OK |
| Activar filtro tipo pago "Al contado" | Se activa el filtro de tipo de pago y se selecciona "Al contado" | Happy Path | OK |
| Cambiar a "Credito" | Se cambia la seleccion del filtro a "Credito" | Happy Path | OK |
| Activar filtro por fecha | Se activa el filtro de fecha y se selecciona un rango de fechas mediante el selector | Happy Path | OK |
| Toggle fecha off resetea | Se desactiva el filtro de fecha. Los valores seleccionados se limpian | Error Path | OK |
| Aplicar filtros | Se confirma la aplicacion de los filtros seleccionados. El sistema retorna al listado filtrado | Happy Path | OK |
| Back desde filtros sin aplicar | Se retrocede desde la pantalla de filtros sin aplicar cambios. El listado permanece sin modificaciones | Error Path | OK |

**Total casos: 10**

#### Sales Detail

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver venta credito en listado | La venta a credito aparece en el listado de ventas | Happy Path | OK |
| Navegar a detalle | Se selecciona una venta del listado. El sistema abre la pantalla de detalle de la venta | Happy Path | OK |
| Ver datos de venta | La pantalla de detalle muestra el monto total, monto cancelado y tipo de venta | Happy Path | OK |
| Generar PDF desde print | Se genera el PDF de la venta. El visor de PDF se abre con el documento generado | Happy Path | OK |
| Compartir PDF | Se comparte el PDF generado a traves de las opciones del sistema | Happy Path | OK |
| Volver del visor | Se retrocede desde el visor de PDF. El sistema retorna a la pantalla de detalle de la venta | Happy Path | OK |
| Abrir dialogo cancelar deuda | Se accede a la opcion de pago. Aparece el dialogo "Cancelar deuda" con el monto pendiente | Happy Path | OK |
| Monto invalido (0) | Se ingresa un monto igual a cero. Aparece el mensaje de error "Monto invalido" | Error Path | OK |
| Monto excedido | Se ingresa un monto superior a la deuda pendiente. Aparece el mensaje de error "Monto excedido" | Error Path | OK |
| Monto valido y pago exitoso | Se ingresa un monto valido y se confirma el pago. Aparece el dialogo de exito "Pago registrado" | Happy Path | OK |
| Anular venta | Se anula la venta a traves de la opcion correspondiente. Se confirma la anulacion en el dialogo de confirmacion | Happy Path | OK |
| Regresar a SalesPage | Despues de anular la venta, el sistema retorna a la pantalla principal de ventas | Happy Path | OK |
| Error de API al cargar detalle | Ocurre un error en la API al cargar los datos de la venta. Aparece el mensaje de error correspondiente | Error Path | OK |

**Total casos: 13**

#### Sales Search Boleta (7 casos)

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver venta con codigo_boleta en listado | La venta seed aparece con su codigo_boleta visible en el listado | Happy Path | OK |
| Abrir campo de busqueda | Se activa la opcion de busqueda. El campo de texto se muestra | Happy Path | OK |
| Buscar por codigo_boleta | Se ingresa el codigo exacto. El listado se filtra mostrando solo la venta buscada | Happy Path | OK |
| Limpiar busqueda | Se restaura el listado completo al limpiar el campo de busqueda | Happy Path | OK |
| Cerrar campo de busqueda | Se desactiva la busqueda. El campo de texto se oculta | Happy Path | OK |
| Codigo no existe | Se ingresa un codigo que no corresponde a ninguna venta. Aparece el mensaje "No se encontraron ventas" | Error Path | OK |
| Codigo parcial con wildcard | El sistema soporta busqueda parcial para encontrar ventas por fragmentos del codigo | Happy Path | OK |

**Total casos: 7**

#### Sales Credito Existing Client (10 casos)

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Crear venta y navegar a pago | Se agrega un producto al carrito y se confirma la venta. El sistema navega a la pantalla de pago | Happy Path | OK |
| Toggle a Credito | Se selecciona el tipo de pago "Credito" en lugar de "Al contado" | Happy Path | OK |
| Buscar cliente existente | Se abre el dialogo de busqueda para seleccionar un cliente registrado | Happy Path | OK |
| Seleccionar cliente | Se elige un cliente de los resultados. El nombre del cliente se asigna al campo correspondiente | Happy Path | OK |
| Ingresar monto parcial | Se ingresa un monto parcial como abono para la venta a credito | Happy Path | OK |
| Confirmar credito exitoso | Se confirma el pago. Aparece el dialogo de exito "Venta registrada" | Happy Path | OK |
| Regresar a SalesPage | Se confirma el dialogo de exito. El sistema navega a la pantalla principal de ventas | Happy Path | OK |

**Total casos: 7**

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Sales Create | si (login) | si | si | si |
| Sales Credito | si (login) | si | si | si |
| Sales List | si (login) | si | no | si |
| Sales Detail | si (login) | si | si | si |
| Sales Search Boleta | si (login) | si | no | si |
| Sales Credito Existing | si (login) | si | si | si |

## 4. Correcciones Aplicadas (Sesion 21/jun/2026)

### 4.1. Fix `sales_list_test.dart` ON CONFLICT
INSERT de usuarios usaba `ON CONFLICT (email)` pero `email` no tiene UNIQUE constraint. Corregido a `ON CONFLICT (id_usuario)` con `id_usuario = 1`, consistente con los demas tests.

## 5. Conclusiones

Los 6 tests E2E de ventas (65 casos) pasan correctamente. Todos los flujos de creacion, listado, detalle, pago, anulacion, busqueda por codigo_boleta y credito con cliente existente estan cubiertos.
