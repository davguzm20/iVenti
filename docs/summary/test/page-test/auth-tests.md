# Auth - Page Tests

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: loading test/page-test/auth/code_email_page_test.dart
00:00 +1: CodeEmailPage
00:01 +2: CreatePinPage
00:01 +3: CreatePinPage
00:01 +4: CreatePinPage
00:01 +5: LoginPage
00:02 +6: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 6 |
| Exitosas | 6 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Carga Inicial | 4 | 4 |
| Estados | 2 | 2 |

## 2. Tests Ejecutados

### 2.1. LoginPage (3 tests)

| # | Descripcion | Tipo |
|---|-------------|------|
| 1 | debe mostrar loading cuando no hay email cargado | Carga Inicial |
| 2 | debe mostrar email del GoRouter extra | Carga Inicial |
| 3 | debe mostrar boton de ingresar y olvidaste PIN | Carga Inicial |

### 2.2. CodeEmailPage (1 test)

| # | Descripcion | Tipo |
|---|-------------|------|
| 1 | debe mostrar el titulo y campo de codigo | Carga Inicial |

### 2.3. CreatePinPage (2 tests)

| # | Descripcion | Tipo |
|---|-------------|------|
| 1 | debe mostrar titulo y campo de PIN | Carga Inicial |
| 2 | debe mostrar email del extra | Carga Inicial |
| 3 | debe obtener email del controller cuando no hay extra | Estados |

## 3. Metodos Evaluados

| Metodo | Carga | Navegacion | Busqueda | Creacion | Estados |
|--------|-------|------------|----------|----------|---------|
| LoginPage | si | no | no | no | si |
| CodeEmailPage | si | no | no | no | no |
| CreatePinPage | si | no | no | no | si |

## 4. Interpretacion

Se verifico la carga inicial de las pantallas de autenticacion, incluyendo la obtencion de email desde GoRouterState y desde el controlador. LoginPage usa GoRouter para navegacion y extra de estado; CreatePinPage obtiene email tanto del extra como del controlador.

## 5. Conclusiones

Las 3 pantallas de autenticacion se renderizan correctamente con sus dependencias mockeadas. Los tests cubren carga inicial, obtencion de parametros de ruta, y estados alternativos (controller lanza excepcion).
