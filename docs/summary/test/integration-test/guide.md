# Guia de Pruebas de Integracion

## 1. Glosario de Terminos

### 1.1. Tipos de Pruebas

| Termino | Definicion |
|---------|------------|
| **Happy Path** | Prueba del caso exitoso donde todo funciona correctamente |
| **Error Path** | Prueba de casos donde algo falla y se debe manejar el error |
| **Validacion** | Prueba de reglas de negocio que validan datos de entrada |
| **Integracion** | Prueba que verifica la interaccion entre multiples componentes |

### 1.2. Terminos Tecnicos

| Termino | Definicion |
|---------|------------|
| **Base de Datos Real** | Instancia de PostgreSQL (Neon) dedicada a pruebas, sin mockear ninguna capa |
| **Setup/Teardown** | Preparacion del estado inicial de la BD y limpieza posterior entre cada prueba |
| **Fixture** | Datos de prueba preparados antes de ejecutar un test |
| **Transaccion** | Bloque de operaciones atomicas contra la BD real (commit/rollback) |
| **Reset** | Restauracion de la BD a un estado base conocido mediante scripts SQL |
| **Assert** | Verificacion que confirma que el resultado es el esperado |

## 2. Estructura de Reportes

Cada reporte de feature sigue la estructura definida en la plantilla y se guarda como `[feature]-tests.md`.

### 2.1. Convencion de Nombres

- **Formato:** `[feature]-tests.md`

### 2.2. Plantilla de Reporte

```markdown
# [Feature] - Pruebas de Integracion

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
| [Operacion] | [n] | [n] |

## 2. Tests Ejecutados

### 2.1. [Service Name] ([n] tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | [method] | [descripcion] | [tipo] |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| [method] | [si/no] | [si/no] | [si/no] |

## 4. Interpretacion

[Descripcion de cobertura, patrones verificados y comportamiento]

## 5. Conclusiones

[Texto libre descriptivo del estado del componente y recomendaciones]
```

## 3. Pruebas Generadas

Los reportes se generan en `docs/summary/test/integration-test/` siguiendo la convencion `[feature]-tests.md`.

## 4. Convenciones de Nomenclatura

### 4.1. Archivos de Test

- **Formato:** `<nombre>_integration_test.dart`
- **Ubicacion:** `test/integration-test/[feature]/`

### 4.2. Grupos de Tests

- **Formato:** `group('Feature.flujo con DB real', () { ... })`

### 4.3. Titulos de Tests

- **Formato:** `test('debe <accion> cuando <condicion> [en BD real]', () { ... })`

## 5. Ejecucion

```bash
# Ejecutar todos los tests de integracion
flutter test test/integration-test/

# Ejecutar tests de una feature especifica
flutter test test/integration-test/[feature]/

# Ejecutar un archivo especifico
flutter test test/integration-test/[feature]/[file]_integration_test.dart
```
