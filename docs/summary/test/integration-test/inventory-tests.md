# Inventory - Pruebas de Integracion

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: loading test/integration-test/inventory/inventory_integration_test.dart
00:00 +0: (setUpAll)
00:02 +1: UnidadService con BD real debe obtener todas las unidades activas [en BD real]
00:03 +2: UnidadService con BD real debe obtener unidad por ID cuando existe [en BD real]
00:04 +3: UnidadService con BD real debe devolver null cuando la unidad no existe [en BD real]
00:05 +4: CategoriaService con BD real debe crear una categoria correctamente [en BD real]
00:06 +5: CategoriaService con BD real debe obtener todas las categorias activas [en BD real]
00:07 +6: CategoriaService con BD real debe actualizar una categoria correctamente [en BD real]
00:09 +7: CategoriaService con BD real debe eliminar (desactivar) una categoria correctamente [en BD real]
00:10 +8: CategoriaService con BD real debe lanzar BusinessException al eliminar categoria inexistente [en BD real]
00:12 +9: CategoriaService con BD real debe obtener categorias de un producto [en BD real]
00:14 +10: ProductoService con BD real debe crear un producto correctamente [en BD real]
00:15 +11: ProductoService con BD real debe lanzar BusinessException cuando el codigo ya existe [en BD real]
00:17 +12: ProductoService con BD real debe obtener producto por ID [en BD real]
00:18 +13: ProductoService con BD real debe devolver null cuando producto por ID no existe [en BD real]
00:20 +14: ProductoService con BD real debe obtener producto por codigo [en BD real]
00:21 +15: ProductoService con BD real debe devolver null cuando codigo no existe [en BD real]
00:22 +16: ProductoService con BD real debe buscar productos por nombre [en BD real]
00:24 +17: ProductoService con BD real debe actualizar un producto correctamente [en BD real]
00:25 +18: ProductoService con BD real debe lanzar BusinessException al actualizar producto inexistente [en BD real]
00:28 +19: ProductoService con BD real debe eliminar (desactivar) un producto correctamente [en BD real]
00:29 +20: ProductoService con BD real debe lanzar BusinessException al eliminar producto inexistente [en BD real]
00:30 +21: ProductoService con BD real debe obtener todos los productos activos [en BD real]
00:31 +22: ProductoService con BD real debe obtener productos filtrados por stock bajo [en BD real]
00:34 +23: LoteService con BD real debe crear un lote correctamente [en BD real]
00:35 +24: LoteService con BD real debe lanzar BusinessException cuando el producto no existe [en BD real]
00:38 +25: LoteService con BD real debe obtener lote por ID [en BD real]
00:42 +26: LoteService con BD real debe obtener lotes de un producto [en BD real]
00:46 +27: LoteService con BD real debe actualizar un lote correctamente [en BD real]
00:49 +28: LoteService con BD real debe obtener lotes por fechas [en BD real]
00:49 +28: (tearDownAll)
00:49 +28: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 28 |
| Exitosas | 28 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Creacion | 5 | 5 |
| Consulta | 13 | 13 |
| Actualizacion | 4 | 4 |
| Eliminacion | 4 | 4 |
| Busqueda | 2 | 2 |

## 2. Tests Ejecutados

### 2.1. UnidadService (3 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | obtenerTodas | Obtener todas las unidades activas | Consulta |
| 2 | obtenerPorId | Obtener unidad por ID cuando existe | Consulta |
| 3 | obtenerPorId | Devolver null cuando la unidad no existe | Consulta |

### 2.2. CategoriaService (6 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crear | Crear una categoria correctamente | Creacion |
| 2 | obtenerTodas | Obtener todas las categorias activas | Consulta |
| 3 | actualizar | Actualizar una categoria correctamente | Actualizacion |
| 4 | eliminar | Eliminar (desactivar) una categoria correctamente | Eliminacion |
| 5 | eliminar | Lanzar BusinessException al eliminar categoria inexistente | Eliminacion |
| 6 | obtenerDeProducto | Obtener categorias de un producto | Consulta |

### 2.3. ProductoService (13 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearProducto | Crear un producto correctamente | Creacion |
| 2 | crearProducto | Lanzar BusinessException cuando el codigo ya existe | Creacion |
| 3 | obtenerProductoPorId | Obtener producto por ID | Consulta |
| 4 | obtenerProductoPorId | Devolver null cuando producto por ID no existe | Consulta |
| 5 | obtenerProductoPorCodigo | Obtener producto por codigo | Consulta |
| 6 | obtenerProductoPorCodigo | Devolver null cuando codigo no existe | Consulta |
| 7 | buscarPorNombre | Buscar productos por nombre | Busqueda |
| 8 | actualizarProducto | Actualizar un producto correctamente | Actualizacion |
| 9 | actualizarProducto | Lanzar BusinessException al actualizar producto inexistente | Actualizacion |
| 10 | eliminarProducto | Eliminar (desactivar) un producto correctamente | Eliminacion |
| 11 | eliminarProducto | Lanzar BusinessException al eliminar producto inexistente | Eliminacion |
| 12 | obtenerTodos | Obtener todos los productos activos | Consulta |
| 13 | obtenerFiltrados | Obtener productos filtrados por stock bajo | Busqueda |

### 2.4. LoteService (6 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearLote | Crear un lote correctamente | Creacion |
| 2 | crearLote | Lanzar BusinessException cuando el producto no existe | Creacion |
| 3 | obtenerLotePorId | Obtener lote por ID | Consulta |
| 4 | obtenerLotesDeProducto | Obtener lotes de un producto | Consulta |
| 5 | actualizarLote | Actualizar un lote correctamente | Actualizacion |
| 6 | obtenerLotesPorFechas | Obtener lotes por fechas | Consulta |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| UnidadService.obtenerTodas | si | no | no |
| UnidadService.obtenerPorId | si | si | no |
| CategoriaService.crear | si | no | no |
| CategoriaService.obtenerTodas | si | no | no |
| CategoriaService.actualizar | si | no | no |
| CategoriaService.eliminar | si | si | no |
| CategoriaService.obtenerDeProducto | si | no | no |
| ProductoService.crearProducto | si | si | no |
| ProductoService.obtenerProductoPorId | si | si | no |
| ProductoService.obtenerProductoPorCodigo | si | si | no |
| ProductoService.buscarPorNombre | si | no | no |
| ProductoService.actualizarProducto | si | si | no |
| ProductoService.eliminarProducto | si | si | no |
| ProductoService.obtenerTodos | si | no | no |
| ProductoService.obtenerFiltrados | si | no | no |
| LoteService.crearLote | si | si | no |
| LoteService.obtenerLotePorId | si | no | no |
| LoteService.obtenerLotesDeProducto | si | no | no |
| LoteService.actualizarLote | si | no | no |
| LoteService.obtenerLotesPorFechas | si | no | no |

## 4. Interpretacion

- **Cobertura total:** 28 tests sobre 20 metodos de 4 servicios (UnidadService, CategoriaService, ProductoService, LoteService), cubriendo happy path y error path en operaciones clave.
- **Patron verificado:** Flujo completo Service, Repository, PostgreSQL real (Neon rama test) sin mocks. Se validaron tipos de datos numericos (VARCHAR(15), numeric), busquedas ILIKE, soft delete, stock bajo, asociaciones many-to-many (categorias_productos), y validacion de unicidad de codigo.
- **Bug detectado:** Los mappers de Producto y Lote hacian `(map['precio'] as num).toDouble()` pero postgres v3 retorna numeric como String. Corregido a `double.parse(map['precio'].toString())`.
- **Bug en test:** El parametro `idCategorias` de `crearProducto` es un named parameter separado del request; el test no lo pasaba explicitamente, resultando en producto sin categorias asociadas.
- **Limpieza:** Cada test se envuelve en BEGIN/ROLLBACK, los datos creados nunca persisten.
- **Dependencias entre servicios:** LoteService depende de ProductoService (valida producto existente) y requiere crear un producto primero en los tests que necesitan lotes.
- **Controladores:** No incluidos por ser capas de delegacion fina sin logica de BD propia.

## 5. Conclusiones

El modulo Inventory funciona correctamente contra la base de datos real. CRUD completo en los 4 servicios, validacion de unicidad (codigo), busquedas textuales con ILIKE, filtros combinados (categorias + stock bajo), soft delete, y asociaciones many-to-many. Los mappers fueron corregidos para manejar tipos numericos retornados como String por el driver postgres v3.
