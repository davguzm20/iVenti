# Reports - Pruebas de Integracion

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: loading test/integration-test/reports/reports_integration_test.dart
00:00 +0: (setUpAll)
00:00 +0: ReportService con BD real generarReporteVentas debe devolver lista en rango de fechas [en BD real]
00:01 +1: ReportService con BD real generarReporteProductosVendidos debe devolver lista en rango de fechas [en BD real]
00:02 +2: ReportService con BD real generarReporteLotes debe devolver lista en rango de fechas [en BD real]
00:03 +3: ReportService con BD real generarReporteProximosVencer debe devolver lista [en BD real]
00:04 +4: ReportService con BD real generarReporteInventarioGeneral debe devolver lista [en BD real]
00:05 +5: ReportService con BD real debe lanzar ValidationException con fechas invalidas [en BD real]
00:06 +6: (tearDownAll)
00:06 +6: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 6 |
| Exitosas | 6 |
| Fallidas | 0 |

## 2. Tests Ejecutados

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | generarReporteVentas | Devolver lista en rango de fechas | Consulta |
| 2 | generarReporteProductosVendidos | Devolver lista en rango de fechas | Consulta |
| 3 | generarReporteLotes | Devolver lista en rango de fechas | Consulta |
| 4 | generarReporteProximosVencer | Devolver lista | Consulta |
| 5 | generarReporteInventarioGeneral | Devolver lista | Consulta |
| 6 | (ValidationException) | Lanzar ValidationException con fechas invalidas | Validacion |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| generarReporteVentas | si | no | no |
| generarReporteProductosVendidos | si | no | no |
| generarReporteLotes | si | no | no |
| generarReporteProximosVencer | si | no | no |
| generarReporteInventarioGeneral | si | no | no |

## 4. Interpretacion

- **Cobertura total:** 6 tests sobre 5 metodos de ReportService.
- **Bugs detectados:** La SQL de ReportRepository referenciaba `v.codigo_boleta` (columna inexistente) y `c.nombre` (debía ser `c.nombres`). Corregido.
- **Mappers corregidos:** VentaReportMapper y ProductoVendidoMapper tenían el mismo bug de tipos numericos (postgres retorna numeric como String). Corregido a `double.parse(...)`.
- **Sin transacciones internas:** Reports solo ejecuta SELECTs, facilitando el wrapper BEGIN/ROLLBACK por test.

## 5. Conclusiones

El modulo Reports funciona correctamente contra la base de datos real. Los 5 reportes (ventas, productos vendidos, lotes, proximos a vencer, inventario general) ejecutan consultas SQL reales y retornan datos correctamente mapeados.
