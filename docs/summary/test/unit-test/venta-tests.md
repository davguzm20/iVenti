# Sales - Pruebas Unitarias

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +42: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 42 |
| Exitosos | 42 |
| Fallidos | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| VentaService | 15 | 15 |
| PagoService | 11 | 11 |
| VentaController | 11 | 11 |
| VentaRequest | 5 | 5 |

## 2. Tests Ejecutados

### 2.1. VentaService (15 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearVenta | debe crear venta correctamente | Happy Path |
| 2 | crearVenta | debe lanzar BusinessException cuando lote no existe | Error Path |
| 3 | crearVenta | debe lanzar BusinessException cuando stock insuficiente | Validacion |
| 4 | crearVenta | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 5 | obtenerVentaPorId | debe retornar venta cuando existe | Happy Path |
| 6 | obtenerVentaPorId | debe retornar null cuando no existe | Happy Path |
| 7 | obtenerVentaPorId | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 8 | obtenerVentasDeCliente | debe retornar lista de ventas del cliente | Happy Path |
| 9 | obtenerVentasDeCliente | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 10 | obtenerDetallesDeVenta | debe retornar detalles de venta | Happy Path |
| 11 | obtenerDetallesDeVenta | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 12 | anularVenta | debe lanzar BusinessException cuando venta no existe | Error Path |
| 13 | anularVenta | debe lanzar BusinessException cuando venta ya esta anulada | Validacion |
| 14 | obtenerCantidadVendidaPorLote | debe retornar cantidad vendida | Happy Path |
| 15 | obtenerCantidadVendidaPorLote | debe lanzar BusinessException cuando hay DatabaseException | Error Path |

### 2.2. PagoService (11 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | registrarPago | debe registrar pago correctamente | Happy Path |
| 2 | registrarPago | debe lanzar BusinessException cuando monto es <= 0 | Validacion |
| 3 | registrarPago | debe lanzar BusinessException cuando venta no existe | Error Path |
| 4 | registrarPago | debe lanzar BusinessException cuando venta esta anulada | Error Path |
| 5 | registrarPago | debe lanzar BusinessException cuando monto excede saldo pendiente | Validacion |
| 6 | registrarPago | debe lanzar BusinessException cuando hay DatabaseException | Error Path |
| 7 | registrarPago | debe hacer ROLLBACK y no COMMIT cuando crear recibo falla | Error Path |
| 8 | registrarPagoCliente | debe lanzar BusinessException cuando monto es <= 0 | Validacion |
| 9 | registrarPagoCliente | debe lanzar BusinessException cuando cliente no existe | Error Path |
| 10 | obtenerRecibosDeVenta | debe retornar lista de recibos | Happy Path |
| 11 | obtenerRecibosDeVenta | debe lanzar BusinessException cuando hay DatabaseException | Error Path |

### 2.3. VentaController (11 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearVenta | delega a VentaService | Delegacion |
| 2 | obtenerVentaPorId | delega a VentaService | Delegacion |
| 3 | obtenerVentasFiltradas | delega a VentaService | Delegacion |
| 4 | obtenerVentasDeCliente | delega a VentaService | Delegacion |
| 5 | obtenerVentasPorFechas | delega a VentaService | Delegacion |
| 6 | obtenerDetallesDeVenta | delega a VentaService | Delegacion |
| 7 | anularVenta | delega a VentaService | Delegacion |
| 8 | registrarPago | delega a PagoService | Delegacion |
| 9 | registrarPagoCliente | delega a PagoService | Delegacion |
| 10 | obtenerRecibosDeVenta | delega a PagoService | Delegacion |
| 11 | obtenerCantidadVendidaPorLote | delega a VentaService | Delegacion |

### 2.4. CrearVentaRequest (5 tests) — NUEVO

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | constructor | 3 productos producen 3 detalles en la request | Happy Path |
| 2 | constructor | detalles vacios lanza ValidationException | Validacion |
| 3 | constructor | request sin idCliente es valida (cliente ocasional) | Happy Path |
| 4 | constructor | request al contado con pago incompleto lanza ValidationException | Validacion |
| 5 | constructor | request a credito no necesita monto completo | Happy Path |

## 3. Metodos Evaluados

### 3.1. VentaService

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| crearVenta | si | si | si (stock, lote) |
| obtenerVentaPorId | si | si | no |
| obtenerVentasDeCliente | si | si | no |
| obtenerDetallesDeVenta | si | si | no |
| anularVenta | no | si | si (estado, existencia) |
| obtenerCantidadVendidaPorLote | si | si | no |

### 3.2. PagoService

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| registrarPago | si | si | si (monto, saldo) |
| registrarPagoCliente | no | si | si (monto) |
| obtenerRecibosDeVenta | si | si | no |

## 4. Cambios Aplicados (Sesion 11/jun/2026)

1. **PagoService.registrarPago**: ahora usa `BEGIN/COMMIT/ROLLBACK` via `_datasource.connection`. Test actualizado con `_FakeConnection` que mockea `Connection.execute`.
2. **Nuevo test ROLLBACK**: verifica que si `crearReciboConRequest` falla, se ejecuta ROLLBACK y NO COMMIT.
3. **Nuevo**: `venta_request_test.dart` (5 tests) — valida CrearVentaRequest con batch de productos, validaciones de pago contado/credito.

## 5. Conclusiones

VentaService, PagoService, VentaController y CrearVentaRequest estan completamente probados con 42 tests aprobados (100%). Se agrego cobertura de transacciones atomicas (ROLLBACK) y validaciones de request.
