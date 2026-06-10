# Reports - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
[PENDING - to be filled after execution]
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 2 |
| Exitosas | 0 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Flujo Completo | 2 | 0 |

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
| Ver los 5 reportes en menu | 5 ReportCards visibles con sus titulos | Happy Path | PENDING |
| Navegar a Productos Vendidos | Se toca card. Se abre la pagina con boton Generar | Happy Path | PENDING |
| Volver al menu | Arrow back. Se regresa a ReportsPage | Happy Path | PENDING |
| Navegar a Lotes | Se toca card. Se abre la pagina | Happy Path | PENDING |
| Navegar a Proximos a Vencer | Se toca card. Se abre la pagina | Happy Path | PENDING |

**Total casos: 5**

#### Report Vencimientos

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Campo prellenado con 8 | Al abrir la pagina, el campo "Dias" tiene valor 8 | Happy Path | PENDING |
| Generar con dato valido | Se toca Generar con 8 dias. Se abre ReportResultsPage | Happy Path | PENDING |
| Ver tabla de resultados | La tabla muestra headers y filas de datos | Happy Path | PENDING |
| Volver con boton Volver | Se toca Volver. Se regresa a la pagina del reporte | Happy Path | PENDING |

**Total casos: 4**

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Reports Page | si (login) | si | no | si |
| Report Vencimientos | si (login) | si | no | si |

## 4. Interpretacion

Se cubre la navegacion del menu de reportes (5 tipos) y el flujo de generacion de resultados con la nueva pagina ReportResultsPage. Los reportes ahora muestran datos en tabla en lugar de solo un SnackBar con un conteo. Los reportes con date picker nativo (ReportSalesPage, ReportProductosVendidosPage, etc.) no se testean en E2E debido a la limitacion de showDatePicker con flutter driver.

## 5. Conclusiones

[PENDING - to be filled after execution]
