# Guia de Pruebas E2E

## 1. Glosario de Terminos

### 1.1. Tipos de Pruebas

| Termino | Definicion |
|---------|------------|
| **Flujo Completo** | Prueba que recorre un caso de uso de extremo a extremo (login, accion, resultado) |
| **Autenticacion** | Prueba que valida el flujo de inicio de sesion, registro y recuperacion de PIN |
| **Navegacion** | Prueba que verifica la navegacion entre pantallas via GoRouter |
| **CRUD** | Prueba que valida la creacion, lectura, actualizacion y eliminacion de registros |

### 1.2. Terminos Tecnicos

| Termino | Definicion |
|---------|------------|
| **integration_test** | Paquete oficial de Flutter para pruebas E2E que corre la app completa en un dispositivo o emulador |
| **WidgetTester** | Controlador de pruebas que permite interactuar con la UI (tap, scroll, input) |
| **Test DB** | Instancia de PostgreSQL (Neon) configurada via `.env.test` para ejecutar pruebas |
| **Setup** | Preparacion del estado inicial de la BD (usuario test, datos semilla) |
| **Teardown** | Limpieza de datos creados durante los tests para dejar la BD consistente |
| **Fixture** | Datos de prueba preparados antes de ejecutar un test (usuario, productos, clientes) |
| **Seed Data** | Datos base que deben existir en la BD para que la app funcione (unidades, categorias) |

## 2. Estructura de Reportes

Cada reporte de feature sigue la estructura definida en la plantilla y se guarda como `[feature]-tests.md`.

### 2.1. Convencion de Nombres

- **Formato:** `[feature]-tests.md`

### 2.2. Plantilla de Reporte

```markdown
# [Feature] - Pruebas E2E

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

[Captura de la output de flutter test]

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | [numero] |
| Exitosas | [numero] |
| Fallidas | [numero] |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| [Flujo Completo] | [n] | [n] |
| [Autenticacion] | [n] | [n] |
| [CRUD] | [n] | [n] |

## 2. Tests Ejecutados

### 2.1. [Feature] ([n] tests)

| # | Flujo | Descripcion | Tipo |
|---|-------|-------------|------|
| 1 | [flujo] | [descripcion] | [tipo] |

### 2.2. Desglose de Casos por Flujo

Cada flujo de prueba contiene casos individuales que verifican comportamientos especificos de la aplicacion. Los casos se clasifican en Happy Path (flujo valido) y Error Path (escenarios de error esperados).

Los resultados se reportan por cada flujo de la siguiente forma:

#### [Nombre del flujo]

| Caso | Descripcion | Tipo | Estado |
|------|-------------|------|--------|
| [nombre del caso] | [descripcion del escenario y comportamiento esperado] | [Happy Path / Error Path] | [OK / FALLIDO] |

## 3. Flujos Evaluados

| Flujo | Autenticacion | Navegacion | CRUD | Cleanup |
|-------|---------------|------------|------|---------|
| [flujo] | [si/no] | [si/no] | [si/no] | [si/no] |

## 4. Interpretacion

[Descripcion de cobertura, flujos verificados y comportamiento de la app]

## 5. Conclusiones

[Texto libre descriptivo del estado de la app y recomendaciones]
```

## 3. Pruebas Generadas

Los reportes se generan en `docs/summary/test/e2e-test/` siguiendo la convencion `[feature]-tests.md`.
Los archivos de prueba se ubican en `test/e2e-test/[feature]/`.

> **Nota:** Los tests con muchos `runAsync` (register, config, recover) usan timeout de 240s.

## 4. Convenciones de Nomenclatura

### 4.1. Archivos de Test

- **Formato:** `<feature>_test.dart`
- **Ubicacion:** `test/e2e-test/[feature]/`
- **Ejemplo:** `test/e2e-test/[feature]/[feature]_test.dart`

### 4.2. Estructura del Test

- **Sin grupos:** cada archivo contiene un unico `testWidgets` con el flujo completo
- **Excepcion:** si un feature requiere multiples flujos independientes, se usa `group()` opcionalmente

### 4.3. Titulos de Tests

- **Formato:** `'[Feature] - flujo completo con todos los casos [tipo]'`
- **Ejemplo:** `'[Feature] - flujo completo con todos los casos [tipo]'`

## 5. Ejecucion

```bash
# JDK 17 requerido
set "JAVA_HOME=<ruta-al-jdk-17>"

# Arranque optimizado del emulador
<emulator-path> -avd <avd-name> -gpu host -no-boot-anim -no-audio -no-snapshot

# Ejecutar un test especifico
flutter drive --driver=test/e2e-test/driver.dart --target=test/e2e-test/[feature]/[feature]_test.dart -d <device>
```
