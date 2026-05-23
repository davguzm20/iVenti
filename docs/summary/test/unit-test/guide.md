# Guia de Pruebas Unitarias

## 1. Glosario de Terminos

### 1.1. Tipos de Pruebas

| Termino | Definicion |
|---------|------------|
| **Happy Path** | Prueba del caso exitoso donde todo funciona correctamente |
| **Error Path** | Prueba de casos donde algo falla y se debe manejar el error |
| **Validacion** | Prueba de reglas de negocio que validan datos de entrada |
| **Delegacion** | Prueba que verifica que un controller llama al service correcto |

### 1.2. Terminos Tecnicos

| Termino | Definicion |
|---------|------------|
| **Mock** | Objeto simulado que reemplaza una dependencia real para aislar la prueba |
| **Stub** | Respuesta predefinida que un mock devuelve cuando se le llama |
| **Fixture** | Datos de prueba preparados antes de ejecutar un test |
| **Assert** | Verificacion que confirma que el resultado es el esperado |

## 2. Estructura de Reportes

Cada reporte de feature sigue la estructura definida en la plantilla y se guarda como `[feature]-tests.md`.

### 2.1. Convencion de Nombres

- **Formato:** `[feature]-tests.md`
- **Ejemplo:** `auth-tests.md`

### 2.2. Plantilla de Reporte

```markdown
# [Feature] - Pruebas Unitarias

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
| [Service] | [n] | [n] |
| [Controller] | [n] | [n] |

## 2. Tests Ejecutados

### 2.1. [Service Name] ([n] tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | [method] | [descripcion] | [tipo] |

### 2.2. [Controller Name] ([n] tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | [method] | [descripcion] | [tipo] |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| [method] | [si/no] | [si/no] | [si/no] |

## 4. Interpretacion

[C descripcion de cobertura, patrones verificados y comportamiento de controllers]

## 5. Conclusiones

[Texto libre descriptivo del estado del componente y recomendaciones]
```

## 3. Documentos Generados

Los reportes se generan en `docs/summary/test/unit-test/` siguiendo la convencion `[feature]-tests.md`.

## 4. Convenciones de Nomenclatura

### 4.1. Archivos de Test

- **Formato:** `<nombre>_test.dart`
- **Ubicacion:** `test/unit-test/[feature]/[type]/`

### 4.2. Grupos de Tests

- **Formato:** `group('Clase.metodo', () { ... })`

### 4.3. Titulos de Tests

- **Formato:** `test('debe <accion> cuando <condicion>', () { ... })`
