# Config - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
config/config_test.dart:   03:05 +3: All tests passed!
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

### 2.1. Config (1 test)

| # | Flujo | Descripcion | Tipo |
|---|-------|-------------|------|
| 1 | Config | Login, edicion de perfil (nombre, dias vencimiento, stock minimo), guardado, navegacion a notificaciones y retorno | Flujo Completo |

### 2.2. Desglose de Casos por Flujo

Cada flujo de prueba contiene casos individuales que verifican comportamientos especificos de la aplicacion. Los casos se clasifican en Happy Path (flujo valido) y Error Path (escenarios de error esperados).

#### Configuracion Inicial (SetupConfigPage)

Los siguientes casos corresponden a la configuracion inicial del usuario. Se ejecutan dentro del flujo de registro (`register_test.dart`).

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Nombre vacio | Se intenta finalizar la configuracion sin ingresar el nombre. El sistema muestra "Nombre requerido" | Error Path | OK |
| Dias vacio | Se intenta finalizar sin ingresar dias de vencimiento. El sistema muestra "Campo incompleto" | Error Path | OK |
| Dias = 0 | Se ingresa 0 en dias de vencimiento. El sistema muestra "Valor invalido" | Error Path | OK |
| Dias negativo | Se ingresa -1 en dias de vencimiento. El sistema muestra "Valor invalido" | Error Path | OK |
| Stock vacio | Se intenta finalizar sin ingresar stock minimo. El sistema muestra "Campo incompleto" | Error Path | OK |
| Stock = 0 | Se ingresa 0 en stock minimo. El sistema muestra "Valor invalido" | Error Path | OK |
| Stock negativo | Se ingresa -1 en stock minimo. El sistema muestra "Valor invalido" | Error Path | OK |
| Configuracion completa | Se completa con datos validos. El sistema muestra "Configuracion completada" y navega a inicio de sesion | Happy Path | OK |

#### Edicion de Configuracion (ConfigPage)

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Nombre vacio | Se borra el nombre y se intenta guardar. El sistema muestra "Nombre requerido" | Error Path | OK |
| Dias de vencimiento vacio | Se borra los dias y se intenta guardar. El sistema muestra "Campo incompleto" | Error Path | OK |
| Dias de vencimiento = 0 | Se ingresa 0 en dias de vencimiento. El sistema muestra "Valor invalido" | Error Path | OK |
| Dias de vencimiento negativo | Se ingresa -1 en dias de vencimiento. El sistema muestra "Valor invalido" | Error Path | OK |
| Stock minimo vacio | Se borra el stock y se intenta guardar. El sistema muestra "Campo incompleto" | Error Path | OK |
| Stock minimo negativo | Se ingresa -1 en stock minimo. El sistema muestra "Valor invalido" | Error Path | OK |
| Guardar configuracion | Se ingresan datos validos y se guarda. El sistema muestra "Configuracion guardada" | Happy Path | OK |
| Re-guardar configuracion | Se guarda nuevamente con datos validos. El sistema muestra "Configuracion guardada" | Happy Path | OK |
| Navegacion a notificaciones | Se accede a notificaciones mediante el icono de campana | Happy Path | OK |
| Retorno a configuracion | Se retrocede desde notificaciones. El sistema regresa a configuracion | Happy Path | OK |

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Config | si (login) | si | si | si |

## 4. Interpretacion

Se cubre la edicion de configuracion de usuario (nombre, dias de vencimiento y stock minimo) y la navegacion a notificaciones. La configuracion inicial (SetupConfigPage) se prueba dentro del flujo de registro y se referencia aqui. Se verificaron 18 casos entre SetupConfigPage (8) y ConfigPage (10). Se aumento el timeout a 240s para garantizar la ejecucion completa de todos los pasos.

## 5. Conclusiones

El modulo de configuracion funciona correctamente para los casos evaluados. La integracion con notificaciones esta verificada.
