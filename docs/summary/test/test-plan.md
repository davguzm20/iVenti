# Test Plan — iVenti

## 1. Historial de versiones

| Versión | Fecha | Autor |
|---------|-------|-------|
| 1.0 | 2026-05-22 | Manuel David Guzman Chavez |

---

## 2. Unit Tests (Pruebas Unitarias)

**Objetivo:** Validar lógica de negocio en Services y delegación en Controllers.

**Alcance:**
- Services: AuthService, ClienteService, ProductoService, CategoriaService, UnidadService, LoteService, VentaService, PagoService, ConfiguracionService, NotificacionService, ReportService
- Controllers: AuthController, ClienteController, ProductoController, CategoriaController, UnidadController, LoteController, VentaController, ConfiguracionController, NotificacionController, ReportController

**Herramientas:** `flutter_test`, `mockito`

**Cobertura esperada:** 100% de métodos públicos (Services y Controllers) con al menos 1 happy path + 1 error path por método

**Estructura:** `test/unit-test/[feature]/[type]/[file]_test.dart`

**Reportes:** `docs/summary/test/unit-test/`

---

## 3. Integration Tests (Pruebas de Integración)

**Objetivo:** Validar interacción con base de datos PostgreSQL y queries SQL.

**Alcance:**
- Repositorios: UsuarioRepository, ClienteRepository, ProductoRepository, LoteRepository, CategoriaRepository, UnidadRepository, VentaRepository, ReciboRepository, ConfiguracionRepository, NotificacionRepository, ReportRepository

**Herramientas:** `test`, PostgreSQL real (Neon rama test)

**Entorno:**
- Neon rama `test` con datos de prueba

**Tipos de pruebas:**
- CRUD completo (crear, leer, actualizar, eliminar)
- Transacciones (BEGIN, COMMIT, ROLLBACK)
- Queries con filtros y joins
- Manejo de excepciones de base de datos

**Estructura:** `test/integration-test/[feature]/[feature]_integration_test.dart`

**Reportes:** `docs/summary/test/integration-test/`

---

## 4. Widget Tests (Pruebas de Componentes UI)

**Objetivo:** Validar renderizado e interacción de componentes visuales reutilizables.

**Alcance:**
- Botones personalizados
- Campos de formulario (texto, numéricos, fechas)
- Tarjetas de productos, clientes, ventas
- Diálogos de confirmación y errores
- Listados y tablas
- Menús desplegables

**Herramientas:** `flutter_test` con `MaterialApp` wrapper

**Tipos de pruebas:**
- Renderizado correcto con datos válidos
- Interacción (clicks, input de texto)
- Estados (habilitado, deshabilitado, carga)
- Mensajes de error y validación

**Reportes:** `docs/summary/widget-test/`

---

## 5. Page Tests (Pruebas de Pantallas)

**Objetivo:** Validar flujo completo de pantallas individuales con Provider.

**Alcance:**
- LoginPage
- CreateSalePage
- SalesPage
- InventoryPage
- ProductPage
- ClientsPage
- DetailsClientPage
- ConfigPage
- NotificationsPage
- Reportes (ventas, productos, lotes, inventario)

**Herramientas:** `flutter_test`, `provider`, mocks de Controllers

**Tipos de pruebas:**
- Carga inicial de datos
- Navegación entre pestañas
- Búsqueda y filtrado
- Creación/edición de registros
- Manejo de estados de carga y error

**Reportes:** `docs/summary/page-test/`

---

## 6. End-to-End Tests (E2E)

**Objetivo:** Validar flujos de negocio completos de extremo a extremo.

**Alcance:**
- Login → Crear venta → Registrar pago
- Login → Crear producto → Agregar lote → Vender producto
- Login → Registrar cliente → Crear venta a crédito → Cobrar deuda
- Login → Configurar parámetros → Verificar impacto en reportes
- Login → Generar notificaciones → Verificar listado

**Herramientas:** `integration_test`, `flutter_driver`

**Entorno:** Base de datos de prueba con datos semilla

**Reportes:** `docs/summary/e2e-test/`

---

## 7. Performance Tests (Pruebas de Rendimiento)

**Objetivo:** Validar tiempos de respuesta en operaciones críticas.

**Alcance:**
- Queries de listados con paginación (ventas, productos, clientes)
- Búsquedas por nombre/código
- Reportes con rangos de fecha amplios
- Operaciones de carga masiva

**Métricas:**
- Tiempo de respuesta < 2 segundos para consultas simples
- Tiempo de respuesta < 5 segundos para reportes complejos
- Uso de memoria estable sin fugas
- Consumo de CPU aceptable en operaciones frecuentes

**Herramientas:** `benchmark_harness`, profiling con Flutter DevTools

**Reportes:** `docs/summary/performance-test/`

---

## 8. Stress Tests (Pruebas de Estrés)

**Objetivo:** Validar comportamiento bajo carga extrema.

**Alcance:**
- Múltiples usuarios concurrentes accediendo a la misma data
- Operaciones de escritura simultáneas (ventas, pagos)
- Consultas complejas con gran volumen de datos
- Conexiones de red intermitentes

**Escenarios:**
- 10+ usuarios realizando ventas simultáneas
- Base de datos con 100K+ registros en tablas principales
- Operaciones de reporte con rangos de fecha de 1+ año
- Pérdida de conexión a mitad de transacción

**Herramientas:** Scripts personalizados, `testcontainers` con datos masivos

**Reportes:** `docs/summary/stress-test/`

---

## 9. Security Tests (Pruebas de Seguridad)

**Objetivo:** Validar manejo seguro de datos sensibles.

**Alcance:**
- Almacenamiento de PINs (encriptación)
- Sesiones de usuario (timeout, cierre)
- Permisos y roles (ADMINISTRADOR vs OPERATIVO)
- Validación de entrada (SQL injection, XSS)

**Herramientas:** Análisis estático, pruebas manuales de penetración

**Reportes:** `docs/summary/security-test/`