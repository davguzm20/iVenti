# Inventory - Pruebas Unitarias

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:03 +76: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 76 |
| Exitosas | 76 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| ProductoService | 17 | 17 |
| ProductoController | 8 | 8 |
| ProductoEntity | 4 | 4 |
| CategoriaService | 10 | 10 |
| CategoriaController | 5 | 5 |
| UnidadService | 5 | 5 |
| UnidadController | 2 | 2 |
| LoteService | 18 | 18 |
| LoteController | 7 | 7 |

## 2. Tests Ejecutados

### 2.1. ProductoService (17 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearProducto | debe crear producto cuando codigo no existe | Happy Path |
| 2 | crearProducto | debe lanzar BusinessException cuando codigo ya existe | Error Path |
| 3 | crearProducto | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 4 | actualizarProducto | debe actualizar producto cuando existe | Happy Path |
| 5 | actualizarProducto | debe lanzar BusinessException cuando producto no existe | Error Path |
| 6 | eliminarProducto | debe eliminar producto cuando existe | Happy Path |
| 7 | eliminarProducto | debe lanzar BusinessException cuando producto no existe | Error Path |
| 8 | obtenerProductoPorId | debe retornar producto cuando existe | Happy Path |
| 9 | obtenerProductoPorId | debe retornar null cuando no existe | Happy Path |
| 10 | obtenerProductoPorCodigo | debe retornar producto cuando existe | Happy Path |
| 11 | obtenerProductoPorCodigo | debe retornar null cuando no existe | Happy Path |
| 12 | buscarPorNombre | debe retornar lista de productos | Happy Path |
| 13 | buscarPorNombre | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 14 | obtenerTodos | debe retornar lista de todos los productos | Happy Path |
| 15 | obtenerTodos | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 16 | obtenerFiltrados | debe retornar productos filtrados | Happy Path |
| 17 | obtenerFiltrados | debe lanzar BusinessException cuando hay DatabaseException | Error Path |

### 2.2. ProductoController (8 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearProducto | delega a ProductoService | Delegacion |
| 2 | actualizarProducto | delega a ProductoService | Delegacion |
| 3 | eliminarProducto | delega a ProductoService | Delegacion |
| 4 | obtenerProductoPorId | delega a ProductoService | Delegacion |
| 5 | obtenerProductoPorCodigo | delega a ProductoService | Delegacion |
| 6 | buscarPorNombre | delega a ProductoService | Delegacion |
| 7 | obtenerTodos | delega a ProductoService | Delegacion |
| 8 | obtenerFiltrados | delega a ProductoService | Delegacion |

### 2.3. ProductoEntity (4 tests) — NUEVO

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | constructor | crear producto con nombre vacio deberia crearse | Happy Path |
| 2 | constructor | stockMinimo default es 0 | Validacion |
| 3 | constructor | producto con todos los campos opcionales null | Happy Path |
| 4 | constructor | producto con codigo unico | Happy Path |

### 2.4. CategoriaService (10 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearCategoria | debe crear categoria correctamente | Happy Path |
| 2 | crearCategoria | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 3 | actualizarCategoria | debe actualizar categoria correctamente | Happy Path |
| 4 | actualizarCategoria | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 5 | eliminarCategoria | debe eliminar categoria correctamente | Happy Path |
| 6 | eliminarCategoria | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 7 | obtenerTodas | debe retornar lista de categorias | Happy Path |
| 8 | obtenerTodas | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 9 | obtenerDeProducto | debe retornar categorias de un producto | Happy Path |
| 10 | obtenerDeProducto | debe lanzar BusinessException cuando hay DatabaseException | Error Path |

### 2.5. CategoriaController (5 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearCategoria | delega a CategoriaService | Delegacion |
| 2 | actualizarCategoria | delega a CategoriaService | Delegacion |
| 3 | eliminarCategoria | delega a CategoriaService | Delegacion |
| 4 | obtenerTodas | delega a CategoriaService | Delegacion |
| 5 | obtenerDeProducto | delega a CategoriaService | Delegacion |

### 2.6. UnidadService (5 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | obtenerTodas | debe retornar lista de unidades | Happy Path |
| 2 | obtenerTodas | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 3 | obtenerPorId | debe retornar unidad cuando existe | Happy Path |
| 4 | obtenerPorId | debe retornar null cuando no existe | Happy Path |
| 5 | obtenerPorId | debe lanzar BusinessException cuando hay DatabaseException | Error Path |

### 2.7. UnidadController (2 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | obtenerTodas | delega a UnidadService | Delegacion |
| 2 | obtenerPorId | delega a UnidadService | Delegacion |

### 2.8. LoteService (18 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearLote | debe crear lote correctamente | Happy Path |
| 2 | crearLote | debe lanzar BusinessException cuando producto no existe | Error Path |
| 3 | crearLote | debe lanzar ValidationException cuando cantidad es menor o igual a 0 | Validacion |
| 4 | actualizarLote | debe actualizar lote correctamente | Happy Path |
| 5 | actualizarLote | debe lanzar BusinessException cuando lote no existe | Error Path |
| 6 | actualizarLote | debe lanzar ValidationException cuando cantidad actual es negativa | Validacion |
| 7 | eliminarLote | debe eliminar lote correctamente | Happy Path |
| 8 | eliminarLote | debe lanzar BusinessException cuando lote no existe | Error Path |
| 9 | eliminarLote | debe lanzar BusinessException cuando lote tiene ventas registradas | Error Path |
| 10 | obtenerLotePorId | debe retornar lote cuando existe | Happy Path |
| 11 | obtenerLotePorId | debe retornar null cuando no existe | Happy Path |
| 12 | obtenerLotePorId | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 13 | obtenerLotesDeProducto | debe retornar lista de lotes de un producto | Happy Path |
| 14 | obtenerLotesDeProducto | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 15 | obtenerLotesPorFechas | debe retornar lista de lotes por rango de fechas | Happy Path |
| 16 | obtenerLotesPorFechas | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 17 | obtenerLotesProximosAVencer | debe retornar lista de lotes proximos a vencer | Happy Path |
| 18 | obtenerLotesProximosAVencer | debe lanzar BusinessException cuando hay DatabaseException | Error Path |

### 2.9. LoteController (7 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearLote | delega a LoteService | Delegacion |
| 2 | actualizarLote | delega a LoteService | Delegacion |
| 3 | eliminarLote | delega a LoteService | Delegacion |
| 4 | obtenerLotePorId | delega a LoteService | Delegacion |
| 5 | obtenerLotesDeProducto | delega a LoteService | Delegacion |
| 6 | obtenerLotesPorFechas | delega a LoteService | Delegacion |
| 7 | obtenerLotesProximosAVencer | delega a LoteService | Delegacion |

## 3. Metodos Evaluados

### 3.1. ProductoService

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| crearProducto | si | si | si (codigo duplicado) |
| actualizarProducto | si | si | no |
| eliminarProducto | si | si | no |
| obtenerProductoPorId | si | si | no |
| obtenerProductoPorCodigo | si | si | no |
| buscarPorNombre | si | si | no |
| obtenerTodos | si | si | no |
| obtenerFiltrados | si | si | no |

### 3.2. CategoriaService

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| crearCategoria | si | si | no |
| actualizarCategoria | si | si | no |
| eliminarCategoria | si | si | no |
| obtenerTodas | si | si | no |
| obtenerDeProducto | si | si | no |

### 3.3. UnidadService

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| obtenerTodas | si | si | no |
| obtenerPorId | si | si | no |

### 3.4. LoteService

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| crearLote | si | si | si (cantidad <= 0) |
| actualizarLote | si | si | si (cantidadActual < 0) |
| eliminarLote | si | si | si (ventas registradas) |
| obtenerLotePorId | si | si | no |
| obtenerLotesDeProducto | si | si | no |
| obtenerLotesPorFechas | si | si | no |
| obtenerLotesProximosAVencer | si | si | no |

## 4. Cambios Aplicados (Sesion 11/jun/2026)

1. **ProductoRepository**: `obtenerProductosRecientes(limite)` en repositorio, servicio y controller. Batch queries en `crearVenta` (INSERT multi-row, UPDATE CASE, CTE stock).
2. **Nuevo**: `producto_entity_test.dart` (4 tests) — valida defaults y campos opcionales de ProductoEntity.

## 5. Conclusiones

Los 4 modulos de Inventory (Producto, Categoria, Unidad, Lote) estan completamente probados con 76 tests aprobados (100%). Se agrego cobertura de la entidad Producto.
