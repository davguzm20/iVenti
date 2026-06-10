# Auth - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
welcome_test.dart:    00:23 +3: All tests passed!
login_test.dart:      01:28 +3: All tests passed!
register_test.dart:   03:02 +3: All tests passed!
recover_test.dart:    02:14 +3: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 4 |
| Exitosas | 4 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Navegacion | 1 | 1 |
| Autenticacion | 3 | 3 |

## 2. Tests Ejecutados

### 2.1. Auth (4 tests)

| # | Flujo | Descripcion | Tipo |
|---|-------|-------------|------|
| 1 | Welcome | Bienvenida, navegar a registro, navegar a login | Navegacion |
| 2 | Login | PIN incompleto, PIN incorrecto, login exitoso | Autenticacion |
| 3 | Register | Email vacio e invalido, codigo vacio e incorrecto, PIN vacio y no coinciden, nombre vacio, config dias vacio/0/-1, stock vacio/0/-1, registro completo | Autenticacion |
| 4 | Recover | Codigo vacio e incorrecto, PIN vacio y no coinciden, login post-recuperacion PIN incorrecto, recuperacion + login exitoso | Autenticacion |

### 2.2. Desglose de Casos por Flujo

Cada flujo de prueba contiene casos individuales que verifican comportamientos especificos de la aplicacion. Los casos se clasifican en Happy Path (flujo valido) y Error Path (escenarios de error esperados).

#### Welcome

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Pantalla de bienvenida | Se muestra la pantalla de bienvenida con las opciones de registro e inicio de sesion | Happy Path | OK |
| Navegar a registro | Se accede al registro mediante la opcion "Registrate aqui" | Happy Path | OK |
| Regresar a bienvenida | Se retrocede desde registro y se vuelve a la pantalla de bienvenida | Happy Path | OK |
| Navegar a login | Se accede al login mediante la opcion "Ya tengo cuenta" | Happy Path | OK |

#### Login

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| PIN incompleto | Se ingresa un PIN de 5 digitos y se intenta iniciar sesion. El sistema muestra el mensaje "PIN incompleto" | Error Path | OK |
| PIN incorrecto | Se ingresa un PIN de 6 digitos incorrecto. El sistema muestra el mensaje "Error de autenticacion" | Error Path | OK |
| Login exitoso | Se ingresa el PIN correcto. El sistema inicia sesion y navega a la pantalla de inventario ("Mis productos") | Happy Path | OK |

#### Register

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Email vacio | Se confirma sin ingresar email. El sistema muestra "Por favor, ingrese su correo" | Error Path | OK |
| Email invalido | Se ingresa un email sin formato valido. El sistema muestra "Ingrese un correo valido" | Error Path | OK |
| Codigo vacio | Se confirma sin ingresar codigo. El sistema muestra dialogo "Error" | Error Path | OK |
| Codigo incorrecto | Se ingresa un codigo de verificacion erroneo. El sistema muestra dialogo "Error" con mensaje de codigo incorrecto | Error Path | OK |
| Codigo correcto | Se ingresa el codigo correcto. El sistema muestra dialogo "Correcto" y avanza a creacion de PIN | Happy Path | OK |
| PIN vacio | Se intenta continuar sin ingresar PIN. El sistema muestra "PIN invalido" | Error Path | OK |
| PINs no coinciden | Se ingresan dos PINs diferentes. El sistema muestra "PIN no coincide" | Error Path | OK |
| Nombre vacio | Se intenta finalizar la configuracion sin nombre. El sistema muestra "Nombre requerido" | Error Path | OK |
| Dias vacio | Se intenta finalizar sin ingresar dias de vencimiento. El sistema muestra "Campo incompleto" | Error Path | OK |
| Dias = 0 | Se ingresa 0 en dias de vencimiento. El sistema muestra "Valor invalido" | Error Path | OK |
| Dias negativo | Se ingresa -1 en dias de vencimiento. El sistema muestra "Valor invalido" | Error Path | OK |
| Stock vacio | Se intenta finalizar sin ingresar stock minimo. El sistema muestra "Campo incompleto" | Error Path | OK |
| Stock = 0 | Se ingresa 0 en stock minimo. El sistema muestra "Valor invalido" | Error Path | OK |
| Stock negativo | Se ingresa -1 en stock minimo. El sistema muestra "Valor invalido" | Error Path | OK |
| Registro completo | Se completa el registro con datos validos. El sistema crea la cuenta y navega a la pantalla de inicio de sesion | Happy Path | OK |

#### Recover

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| Codigo vacio | Se confirma sin ingresar codigo. El sistema muestra dialogo "Error" | Error Path | OK |
| Codigo incorrecto | Se ingresa un codigo de recuperacion erroneo. El sistema muestra dialogo "Error" con mensaje de codigo incorrecto | Error Path | OK |
| Codigo correcto | Se ingresa el codigo correcto. El sistema muestra "Correcto" y avanza a creacion de PIN | Happy Path | OK |
| PIN vacio | Se intenta continuar sin ingresar PIN. El sistema muestra "PIN invalido" | Error Path | OK |
| PINs no coinciden | Se ingresan dos PINs diferentes en la recuperacion. El sistema muestra "PIN no coincide" | Error Path | OK |
| PIN incorrecto post-recuperacion | Se intenta iniciar sesion con el PIN anterior tras la recuperacion. El sistema muestra "Error de autenticacion" | Error Path | OK |
| Recuperacion + login exitoso | Se completa la recuperacion de PIN y se inicia sesion con el nuevo PIN. El sistema navega a inventario | Happy Path | OK |

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| Welcome | no | si | no | si |
| Login | si | si | no | si |
| Register | si | si | no | si |
| Recover | si | si | no | si |

## 4. Interpretacion

Se cubren los cuatro flujos principales de autenticacion: welcome, login, registro y recuperacion de PIN. Cada flujo prueba primero los casos de error (negativos) y luego el camino exitoso. Se verificaron un total de 30 casos individuales entre los 4 flujos (4 Welcome + 3 Login + 15 Register + 7 Recover). Los mensajes de error se validan contra el texto exacto mostrado en dialogo de la aplicacion.

## 5. Conclusiones

El modulo de autenticacion funciona correctamente para todos los casos evaluados. La navegacion entre pantallas es fluida y los mensajes de error se muestran adecuadamente. No se encontraron bugs en la funcionalidad de autenticacion.
