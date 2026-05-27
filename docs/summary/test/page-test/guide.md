# Guia de Pruebas de Pantallas

## 1. Glosario de Terminos

### 1.1. Tipos de Pruebas

| Termino | Definicion |
|---------|------------|
| **Carga Inicial** | Prueba que verifica la carga de datos al abrir la pantalla |
| **Navegacion** | Prueba que valida la navegacion entre pantallas (push, pop, go) |
| **Busqueda y Filtrado** | Prueba que verifica la busqueda y filtrado de datos en listados |
| **Creacion y Edicion** | Prueba que valida la creacion o modificacion de registros |
| **Estados** | Prueba que verifica los estados visuales (carga, vacio, error) |

### 1.2. Terminos Tecnicos

| Termino | Definicion |
|---------|------------|
| **Pantalla (Page)** | Widget completo que representa una vista o pantalla de la aplicacion |
| **Provider Wrapper** | Envoltorio que proporciona los controladores mockeados via Provider al arbol de widgets |
| **Controller Mock** | Objeto Mockito que simula un controlador para aislar la prueba de la capa de negocio |
| **GoRouter Mock** | Configuracion simulada de GoRouter para validar navegacion sin cambiar de ruta |
| **pumpPage** | Funcion helper que construye la pantalla con todos los providers y routing necesarios |
| **StatefulWidget** | Widget con estado que mantiene datos y logica interna de la pantalla |

## 2. Estructura de Reportes

Cada reporte de feature sigue la estructura definida en la plantilla y se guarda como `[feature]_page_tests.md`.

### 2.1. Convencion de Nombres

- **Formato:** `[feature]_page_tests.md`

### 2.2. Plantilla de Reporte

```markdown
# [Feature] - Page Tests

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
| [Carga Inicial] | [n] | [n] |
| [Navegacion] | [n] | [n] |
| [Busqueda] | [n] | [n] |
| [Creacion] | [n] | [n] |
| [Estados] | [n] | [n] |

## 2. Tests Ejecutados

### 2.1. [Page Name] ([n] tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | [metodo] | [descripcion] | [tipo] |

## 3. Metodos Evaluados

| Metodo | Carga | Navegacion | Busqueda | Creacion | Estados |
|--------|-------|------------|----------|----------|---------|
| [metodo] | [si/no] | [si/no] | [si/no] | [si/no] | [si/no] |

## 4. Interpretacion

[Descripcion de cobertura, flujos verificados y comportamiento de la pantalla]

## 5. Conclusiones

[Texto libre descriptivo del estado de la pantalla y recomendaciones]
```

## 3. Pruebas Generadas

Los reportes se generan en `docs/summary/test/page-test/` siguiendo la convencion `[feature]_page_tests.md`.
Los archivos de prueba se ubican en `test/page-test/[feature]/`.

## 4. Convenciones de Nomenclatura

### 4.1. Archivos de Test

- **Formato:** `<feature>_page_test.dart`
- **Ubicacion:** `test/page-test/[feature]/`
- **Ejemplo:** `test/page-test/inventory/inventory_page_test.dart`

### 4.2. Grupos de Tests

- **Formato:** `group('FeaturePage', () { ... })`
- **Subgrupos:** `group('carga inicial', () { ... })`, `group('navegacion', () { ... })`, `group('busqueda', () { ... })`, `group('creacion', () { ... })`, `group('estados', () { ... })`

### 4.3. Titulos de Tests

- **Carga Inicial:** `testWidgets('debe cargar <datos> cuando se inicializa la pantalla', () { ... })`
- **Navegacion:** `testWidgets('debe navegar a <destino> cuando se presiona <elemento>', () { ... })`
- **Busqueda:** `testWidgets('debe filtrar resultados cuando se ingresa <texto>', () { ... })`
- **Creacion:** `testWidgets('debe crear <recurso> cuando se completa el formulario', () { ... })`
- **Estados:** `testWidgets('debe mostrar <estado> cuando <condicion>', () { ... })`

## 5. Ejecucion

```bash
# Ejecutar todos los page tests
flutter test test/page-test/

# Ejecutar tests de una feature especifica
flutter test test/page-test/[feature]/

# Ejecutar un archivo especifico
flutter test test/page-test/[feature]/[feature]_page_test.dart

# Ejecutar con reportero expandido
flutter test test/page-test/ --reporter=expanded
```
