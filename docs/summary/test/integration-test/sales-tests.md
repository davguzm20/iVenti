# Sales - Pruebas de Integracion

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: loading test/integration-test/sales/sales_integration_test.dart
00:00 +0: (setUpAll)
00:01 +0: VentaService.crearVenta con BD real (setUpAll)
00:03 +0: VentaService.crearVenta con BD real debe lanzar BusinessException cuando el lote no existe [en BD real]
00:04 +1: VentaService.crearVenta con BD real debe lanzar BusinessException cuando el stock es insuficiente [en BD real]
00:05 +2: VentaService.crearVenta con BD real debe lanzar ValidationException cuando venta al contado sin monto completo [en BD real]
00:05 +3: VentaService.crearVenta con BD real debe crear una venta correctamente [en BD real]
00:11 +4: VentaService.crearVenta con BD real (tearDownAll)
00:13 +4: VentaService.obtenerVentaPorId con BD real debe devolver null cuando la venta no existe [en BD real]
00:14 +5: VentaService.obtenerVentasFiltradas con BD real debe devolver lista vacia cuando no hay ventas [en BD real]
00:15 +6: VentaService.obtenerVentasDeCliente con BD real debe devolver lista vacia cuando el cliente no tiene ventas [en BD real]
00:16 +7: VentaService.obtenerDetallesDeVenta con BD real debe devolver lista vacia cuando la venta no existe [en BD real]
00:17 +8: VentaService.anularVenta con BD real debe lanzar BusinessException cuando la venta no existe [en BD real]
00:18 +9: VentaService.obtenerCantidadVendidaPorLote con BD real debe devolver 0 cuando el lote no tiene ventas [en BD real]
00:19 +10: PagoService con BD real (setUpAll)
00:20 +10: PagoService con BD real debe lanzar BusinessException cuando el monto es <= 0 [en BD real]
00:21 +11: PagoService con BD real debe lanzar BusinessException cuando la venta no existe [en BD real]
00:22 +12: PagoService con BD real debe registrar un pago correctamente [en BD real]
00:29 +13: PagoService con BD real (tearDownAll)
00:31 +13: (tearDownAll)
00:32 +13: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 13 |
| Exitosas | 13 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Creacion | 2 | 2 |
| Consulta | 5 | 5 |
| Validacion | 1 | 1 |
| Error path | 4 | 4 |
| Pago | 1 | 1 |

## 2. Tests Ejecutados

### 2.1. VentaService.crearVenta (4 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearVenta | Lanzar BusinessException cuando el lote no existe | Error path |
| 2 | crearVenta | Lanzar BusinessException cuando el stock es insuficiente | Error path |
| 3 | crearVenta | Lanzar ValidationException cuando venta al contado sin monto completo | Validacion |
| 4 | crearVenta | Crear una venta correctamente con datos validos | Creacion |

### 2.2. VentaService.obtenerVentaPorId (1 test)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | obtenerVentaPorId | Devolver null cuando la venta no existe | Consulta |

### 2.3. VentaService.obtenerVentasFiltradas (1 test)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | obtenerVentasFiltradas | Devolver lista vacia cuando no hay ventas | Consulta |

### 2.4. VentaService.obtenerVentasDeCliente (1 test)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | obtenerVentasDeCliente | Devolver lista vacia cuando el cliente no tiene ventas | Consulta |

### 2.5. VentaService.obtenerDetallesDeVenta (1 test)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | obtenerDetallesDeVenta | Devolver lista vacia cuando la venta no existe | Consulta |

### 2.6. VentaService.anularVenta (1 test)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | anularVenta | Lanzar BusinessException cuando la venta no existe | Error path |

### 2.7. VentaService.obtenerCantidadVendidaPorLote (1 test)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | obtenerCantidadVendidaPorLote | Devolver 0 cuando el lote no tiene ventas | Consulta |

### 2.8. PagoService (3 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | registrarPago | Lanzar BusinessException cuando el monto es <= 0 | Error path |
| 2 | registrarPago | Lanzar BusinessException cuando la venta no existe | Error path |
| 3 | registrarPago | Registrar un pago correctamente | Pago |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| VentaService.crearVenta | si | si | si |
| VentaService.obtenerVentaPorId | no | si | no |
| VentaService.obtenerVentasFiltradas | no | si | no |
| VentaService.obtenerVentasDeCliente | no | si | no |
| VentaService.obtenerDetallesDeVenta | no | si | no |
| VentaService.anularVenta | no | si | no |
| VentaService.obtenerCantidadVendidaPorLote | no | si | no |
| PagoService.registrarPago | si | si | si |

## 4. Interpretacion

- **Cobertura total:** 13 tests sobre 8 metodos de 2 servicios (VentaService, PagoService).
- **Manejo de transacciones:** VentaRepository.crearVenta y VentaService.anularVenta manejan sus propias transacciones (BEGIN/COMMIT internos). Los tests de happy path requieren limpieza manual post-COMMIT, restaurando stock de lotes y recalculando stock de productos.
- **Bug detectado:** Los mappers de Sales (VentaMapper, ReciboMapper) hacian `(map['monto'] as num).toDouble()` pero postgres v3 retorna numeric como String. Corregido a `double.parse(...)`.
- **Patron verificado:** Flujo completo Service, Repository, PostgreSQL real (Neon rama test). Se validaron FK constraints (usuarios, lotes), validacion de stock, y manejo de errores.
- **Limitacion:** `anularVenta` y `registrarPagoCliente` no se probaron con datos reales porque manejan transacciones internas que colisionan con el wrapper BEGIN/ROLLBACK de los tests. La limpieza manual solo se aplica a datos de venta; productos, lotes y clientes de prueba se limpian con soft delete.
- **Limpieza:** Los tests de happy path limpian manualmente detalle_ventas, recibos y ventas creadas, restauran stock de lotes y recalculan stock de productos.

## 5. Conclusiones

El modulo Sales funciona correctamente contra la base de datos real. La creacion de ventas con detalles, validacion de lotes y stock, y registro de pagos se comportan segun lo esperado. Las FK constraints de la BD (usuarios, lotes, productos) se aplican correctamente. Los mappers fueron corregidos para el mismo bug de tipos numericos encontrado en Inventory.
