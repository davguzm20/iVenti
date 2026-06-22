# Reports - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
# reports_page_test.dart (5 casos)
All tests passed!  (00:56)

# report_vencimientos_test.dart (4 casos)
All tests passed!  (01:00)
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 2 (9 casos) |
| Exitosas | 2 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Flujo Completo | 2 | 2 |

## 2. Tests Ejecutados

### 2.1. Reports (2 tests)

| # | Flujo | Descripcion | Tipo |
|---|-------|-------------|------|
| 1 | Reports Page | Navegacion a todos los reportes desde el menu | Flujo Completo |
| 2 | Report Vencimientos | Validacion de dias y generacion de resultados | Flujo Completo |

### 2.2. Desglose de Casos por Flujo

#### Reports Page

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Ver los 5 reportes en menu | Las 5 opciones de reporte se muestran en el menu principal con sus respectivos titulos | Happy Path | OK |
| Navegar a Productos Vendidos | Se selecciona la opcion de Productos Vendidos. El sistema abre la pagina correspondiente con el boton Generar | Happy Path | OK |
| Volver al menu | Se retrocede desde la pantalla de reporte. El sistema retorna al menu principal de reportes | Happy Path | OK |
| Navegar a Lotes | Se selecciona la opcion de Lotes. El sistema abre la pagina de reporte de lotes | Happy Path | OK |
| Navegar a Proximos a Vencer | Se selecciona la opcion de Proximos a Vencer. El sistema abre la pagina de reporte correspondiente | Happy Path | OK |

**Total casos: 5**

#### Report Vencimientos

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Campo prellenado con 8 | Al ingresar a la pagina, el campo de dias de vencimiento muestra el valor 8 por defecto | Happy Path | OK |
| Generar con dato valido | Se genera el reporte con 8 dias de vencimiento. El sistema abre la pagina de resultados | Happy Path | OK |
| Ver tabla de resultados | La pagina de resultados muestra una tabla con headers y filas de datos | Happy Path | OK |
| Volver con boton Volver | Se retrocede desde la pagina de resultados. El sistema retorna a la pagina de configuracion del reporte | Happy Path | OK |

**Total casos: 4**

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Reports Page | si (login) | si | no | si |
| Report Vencimientos | si (login) | si | no | si |

## 4. Interpretacion

Se cubre la navegacion del menu de reportes (5 tipos) y el flujo de generacion de resultados con la nueva pagina ReportResultsPage. Los reportes ahora muestran datos en tabla en lugar de solo un SnackBar con un conteo. Los reportes con date picker nativo (ReportSalesPage, ReportProductosVendidosPage, etc.) no se testean en E2E debido a la limitacion de showDatePicker con flutter driver.

## 5. Conclusiones

Los 2 tests E2E de reportes (9 casos) pasan correctamente. La navegacion del menu de reportes y la generacion de resultados de vencimientos esta verificada. Los reportes con date picker nativo (ReportSalesPage, ReportProductosVendidosPage) no se testean en E2E por limitacion de flutter driver.
