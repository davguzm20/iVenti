# Guia de Pruebas de Widgets

## 1. Glosario de Terminos

### 1.1. Tipos de Pruebas

| Termino | Definicion |
|---------|------------|
| **Renderizado** | Prueba que verifica que un widget se dibuja correctamente en pantalla |
| **Interaccion** | Prueba que valida la respuesta del widget a eventos del usuario (clicks, input) |
| **Estado** | Prueba que verifica los diferentes estados visuales del widget (activo, inactivo, carga) |
| **Navegacion** | Prueba que valida la navegacion entre pantallas o dialogs |

### 1.2. Terminos Tecnicos

| Termino | Definicion |
|---------|------------|
| **Widget** | Componente visual basico de Flutter (botones, campos, tarjetas, dialogs) |
| **Finder** | Herramienta para localizar widgets en el arbol de UI durante las pruebas |
| **Pump** | Metodo que actualiza el estado del widget y renderiza los cambios visuales |
| **Tester** | Objeto `WidgetTester` que controla la ejecucion de pruebas de widgets |
| **MaterialApp Wrapper** | Contenedor que proporciona el contexto de Material Design necesario para los widgets |

## 2. Estructura de Reportes

Cada reporte de feature sigue la estructura definida en la plantilla y se guarda como `[widget]-tests.md`.

### 2.1. Convencion de Nombres

- **Formato:** `[widget]-tests.md`

### 2.2. Plantilla de Reporte

```markdown
# [Widget] - Widget Tests

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
| [Renderizado] | [n] | [n] |
| [Interaccion] | [n] | [n] |
| [Estados] | [n] | [n] |

## 2. Tests Ejecutados

### 2.1. [Widget Name] ([n] tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | [method] | [descripcion] | [tipo] |

## 3. Metodos Evaluados

| Metodo | Renderizado | Interaccion | Estados |
|--------|------------|-------------|---------|
| [method] | [si/no] | [si/no] | [si/no] |

## 4. Interpretacion

[Descripcion de cobertura, patrones verificados y comportamiento visual]

## 5. Conclusiones

[Texto libre descriptivo del estado del componente y recomendaciones]
```

## 3. Pruebas Generadas

Los reportes se generan en `docs/summary/widget-test/` siguiendo la convencion `[widget]-tests.md`.

## 4. Convenciones de Nomenclatura

### 4.1. Archivos de Test

- **Formato:** `<widget>_test.dart`
- **Ubicacion:** `test/widget-test/[feature]/`
- **Ejemplo:** `test/widget-test/common/custom_button_test.dart`

### 4.2. Grupos de Tests

- **Formato:** `group('WidgetName', () { ... })`
- **Subgrupos:** `group('renderizado', () { ... })`, `group('interaccion', () { ... })`

### 4.3. Titulos de Tests

- **Renderizado:** `testWidgets('debe renderizar correctamente con <propiedad>', () { ... })`
- **Interaccion:** `testWidgets('debe <accion> cuando <evento>', () { ... })`
- **Estados:** `testWidgets('debe mostrar estado <estado>', () { ... })`

## 5. Ejecucion

```bash
# Ejecutar todos los widget tests
flutter test test/widget-test/

# Ejecutar tests de una feature especifica
flutter test test/widget-test/[feature]/

# Ejecutar un archivo especifico
flutter test test/widget-test/[feature]/[widget]_test.dart

# Ejecutar con reportero expandido
flutter test test/widget-test/ --reporter=expanded
```
