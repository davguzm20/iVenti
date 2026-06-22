# Inventory - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
# product_create_test.dart (16 casos)
All tests passed!  (02:54)

# product_list_test.dart (10 casos)
All tests passed!  (02:00)

# product_detail_test.dart (17 casos)
All tests passed!  (02:26)

# barcode_scanner_test.dart (6 casos)
All tests passed!  (00:59)
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 49 |
| Exitosas | 49 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Flujo Completo | 4 | 4 |
| CRUD | 3 | 3 |
| Navegacion | 4 | 4 |

## 2. Tests Ejecutados

### 2.1. Inventory (4 tests, 49 casos)

| # | Flujo | Descripcion | Tipo |
|---|-------|-------------|------|
| 1 | Create Product | Creacion completa con validacion, scanner, imagen y categorias | Flujo Completo |
| 2 | Inventory List | Listado, busqueda y filtros | Flujo Completo |
| 3 | Product Detail | Detalle, lotes, edicion y categorias | Flujo Completo |
| 4 | Barcode Scanner | Escanear desde Crear Producto | Flujo Completo |

### 2.2. Desglose de Casos por Flujo

#### Create Product (16 casos)

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Scanner navegacion + codigo simulado | Se navega a la pantalla de scanner y se simula la captura de un codigo de barras. El codigo se aplica al campo correspondiente | Happy Path | OK |
| Image picker navegacion + ruta simulada | Se navega a la pantalla de seleccion de imagen y se simula la captura de una foto. La ruta de la imagen se aplica al campo correspondiente | Happy Path | OK |
| Campos incompletos | Se intenta confirmar la creacion sin ingresar el nombre del producto. Aparece el mensaje de error "Nombre requerido" | Error Path | OK |
| Stock = 0 | Se ingresa stock minimo igual a cero. Aparece el mensaje de error "Stock minimo invalido" | Error Path | OK |
| Precio = 0 | Se ingresa precio igual a cero. Aparece el mensaje de error "Precio invalido" | Error Path | OK |
| Agregar categoria via dialog | Se crea una nueva categoria a traves del dialogo de categorias. La categoria aparece en la lista disponible | Happy Path | OK |
| Seleccion FilterChip | Se selecciona una categoria mediante el FilterChip. La categoria queda marcada como seleccionada | Happy Path | OK |
| Editar categoria via dropdown | Se renombra una categoria existente a traves del dropdown de edicion. El cambio se guarda correctamente | Happy Path | OK |
| Eliminar categoria via dropdown | Se elimina una categoria a traves del dropdown de eliminacion. La categoria desaparece de la lista | Happy Path | OK |
| Cancelar creacion | Se cancela la creacion del producto. El sistema retorna a la pantalla de inventario sin crear el producto | Happy Path | OK |
| Crear producto exitoso | Se completan todos los campos con datos validos y se confirma la creacion. Aparece el dialogo de exito | Happy Path | OK |
| Producto en lista | El producto creado aparece en el listado de inventario | Happy Path | OK |

#### Inventory List (10 casos)

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Producto en lista | El producto creado aparece en la pantalla "Mis productos" | Happy Path | OK |
| Buscar producto | Se ingresa texto en el campo de busqueda. El listado se filtra mostrando solo los productos coincidentes | Happy Path | OK |
| Limpiar busqueda | Se restaura el listado completo al limpiar el campo de busqueda | Happy Path | OK |
| Filtro stock bajo | Se activa el filtro de stock bajo. El listado muestra solo productos con stock por debajo del minimo | Happy Path | OK |
| Filtro stock normal | Se cambia al filtro de stock normal. El listado muestra solo productos con stock suficiente | Happy Path | OK |
| Filtro categorias combo | Se selecciona una categoria en el combo de filtros. El listado se filtra por la categoria seleccionada | Happy Path | OK |
| Retroceder sin aplicar | Se ingresa a la pantalla de filtros y se retrocede sin aplicar cambios. El listado permanece sin modificaciones | Happy Path | OK |

#### Product Detail (17 casos)

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver detalle | El precio, stock actual, stock minimo y unidad se muestran en la pantalla de detalle | Happy Path | OK |
| Categorias seed | La categoria asignada al producto se muestra como FilterChip en la pantalla de detalle | Happy Path | OK |
| Crear nueva categoria | Se crea una nueva categoria a traves de la opcion de edicion. La categoria se agrega a la lista disponible | Happy Path | OK |
| Agregar categoria via dropdown | Se asigna una categoria existente al producto mediante el dropdown de categorias | Happy Path | OK |
| Eliminar categoria de producto | Se elimina la categoria asignada al producto. La categoria se remueve del producto | Happy Path | OK |
| Sin lotes | Se muestra el mensaje "Aun no hay lotes" cuando el producto no tiene lotes registrados | Happy Path | OK |
| Cancelar agregar lote | Se abre el dialogo de agregar lote y se cancela la operacion. No se realizan cambios | Happy Path | OK |
| Agregar lote valido | Se ingresa cantidad y precio en el dialogo de lote y se guarda. El lote se crea correctamente | Happy Path | OK |
| Lote en lista | El lote creado aparece en el listado de lotes con su cantidad y precio | Happy Path | OK |
| Editar producto | Se accede al dialogo de edicion del producto desde la barra de acciones | Happy Path | OK |
| Cancelar editar | Se abre el dialogo de edicion y se cancela. El producto permanece sin cambios | Happy Path | OK |
| Editar y guardar cambios | Se modifica el nombre del producto y se guarda. El producto se actualiza correctamente | Happy Path | OK |
| Cambios reflejados | El nombre editado del producto se muestra en la barra superior | Happy Path | OK |
| Eliminar lote | Se elimina un lote existente a traves del menu de opciones. El lote se elimina tras la confirmacion | Happy Path | OK |
| Eliminar producto | Se elimina el producto a traves de la barra de acciones. El producto se elimina tras la confirmacion | Happy Path | OK |
| Retorno a inventory | Despues de eliminar el producto, se retrocede a la pantalla "Mis productos". El producto eliminado ya no aparece | Happy Path | OK |

#### Barcode Scanner (6 casos)

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Navegar desde Crear Producto | Se accede a la pantalla de scanner desde la creacion de producto | Happy Path | OK |
| Iniciar camara | El controlador de la camara se inicializa correctamente al abrir el scanner | Happy Path | OK |
| Simular codigo escaneado | Se simula la captura de un codigo de barras mediante el hook de testing. El codigo se registra en el estado | Happy Path | OK |
| Cancelar escaneo | Se cancela el escaneo y se retorna a la pantalla de creacion de producto sin aplicar ningun codigo | Happy Path | OK |
| Codigo en campo | El codigo escaneado aparece en el campo de texto de codigo de barras | Happy Path | OK |
| Multiple escaneos | Se realizan dos escaneos consecutivos. El codigo anterior se reemplaza por el nuevo | Happy Path | OK |

**Total casos: 6**

### Fixes aplicados en sesión 21/jun/2026
- `pubspec.yaml` - `pinput` actualizado de `^5.0.1` a `^6.0.2` para evitar `IntrinsicWidth` assert en debug
- `lib/features/inventory/widgets/ProductCard.dart` - `Row` envuelto en `FittedBox` + `ClipRect` para evitar overflow de `RenderFlex`
- `lib/main.dart` - `FlutterError.onError` siempre reenvía (sin `if (!isTest)`)
- Tests E2E ahora se ejecutan en `--debug` (no `--profile`)

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Create Product | Si (login) | Si (scanner, image picker, categorias) | Si (crear) | Si |
| Inventory List | Si (login) | Si (filtros, back) | Si (leer) | Si |
| Product Detail | Si (login) | Si (dialogos) | Si (leer, actualizar, eliminar) | Si |
| Barcode Scanner | Si (login) | Si (navegacion) | No | Si |

## 4. Interpretacion

Cobertura completa de los flujos de inventory. Todos los casos de CRUD para productos y lotes estan validados:
- **Crear**: validacion de campos (incompletos, stock invalido, precio invalido) y creacion exitosa
- **Leer**: listado, busqueda por texto, filtros por stock y categoria
- **Actualizar**: edicion de producto, edicion de categoria (rename), asignacion/eliminacion de categorias
- **Eliminar**: eliminacion de producto, eliminacion de lote, eliminacion de categoria

Los sub-dialogs de categorias (editar/eliminar via DropdownButtonFormField) se interactuan exitosamente mediante `tester.state<FormFieldState<int>>().didChange()` con finder acotado al AlertDialog.

Los hooks de testing (BarcodeScannerPage.testCodigoSimulado, ImagePickerPage.testRutaSimulada) permiten simular escaneo de codigo y seleccion de imagen sin hardware real.

Los bugs de ProductPage fueron corregidos:
- `_eliminarCategoriaDeProducto` ahora llama a la API
- `_showAgregarCategoriaAProducto` ahora persiste la asignacion via API

## 5. Conclusiones

Los 49 casos E2E de inventory pasan correctamente. La funcionalidad de categorias, lotes, busqueda, filtros y scanner (simulado) esta completamente cubierta. Los unicos flujos no automatizables en E2E son el escaneo real de codigos de barras y la captura de fotos real, que requieren hardware fisico.
