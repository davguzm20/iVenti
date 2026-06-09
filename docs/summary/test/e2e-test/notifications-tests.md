# Notifications - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
notifications/notifications_test.dart:   01:29 +3: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 1 |
| Exitosas | 1 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Flujo Completo | 1 | 1 |

## 2. Tests Ejecutados

### 2.1. Notifications (1 test)

| # | Flujo | Descripcion | Tipo |
|---|-------|-------------|------|
| 1 | Notifications | Login, navegacion a notificaciones, listar, eliminar, marcar todo leido, limpiar historial y retroceder | Flujo Completo |

### 2.2. Desglose de Casos por Flujo

Cada flujo de prueba contiene casos individuales que verifican comportamientos especificos de la aplicacion. Los casos se clasifican en Happy Path (flujo valido) y Error Path (escenarios de error esperados).

#### Notifications

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Login | Se inicia sesion con credenciales validas. El sistema navega a inventario | Happy Path | OK |
| Navegar a configuracion | Se accede a la pantalla de configuracion desde inventario | Happy Path | OK |
| Navegar a notificaciones | Se accede a notificaciones mediante el icono de campana | Happy Path | OK |
| Listar notificaciones | Se muestran las 3 notificaciones de prueba insertadas | Happy Path | OK |
| Eliminar notificacion | Se elimina una notificacion individual. La notificacion desaparece de la lista | Happy Path | OK |
| Marcar todo como leido | Se marcan todas las notificaciones como leidas. Los iconos de no leidas desaparecen | Happy Path | OK |
| Limpiar historial | Se eliminan todas las notificaciones. Se muestra "No hay notificaciones" | Happy Path | OK |
| Retroceder a configuracion | Se regresa a configuracion mediante el boton de retroceso | Happy Path | OK |

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Notifications | si (login) | si | si (delete) | si |

## 4. Interpretacion

Se cubre el flujo completo de notificaciones: login, navegacion, listado, eliminacion individual, marcado como leido, limpieza total y retorno a configuracion. Se insertaron 3 notificaciones de prueba (STOCK_BAJO, PROXIMO_VENCER, STOCK_AGOTADO) con diferentes estados de leida para verificar el comportamiento correcto.

## 5. Conclusiones

El modulo de notificaciones funciona correctamente para los casos evaluados. La eliminacion individual y la limpieza total del historial se comportan como se espera. La navegacion de regreso a configuracion es correcta.
