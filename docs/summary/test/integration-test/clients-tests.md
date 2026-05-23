# Clients - Pruebas de Integracion

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: loading test/integration-test/clients/clients_integration_test.dart
00:00 +0: (setUpAll)
00:01 +1: ClienteService.crearCliente con BD real debe crear un cliente correctamente cuando los datos son validos [en BD real]
00:02 +2: ClienteService.crearCliente con BD real debe crear un cliente sin dni, email y telefono cuando son opcionales [en BD real]
00:04 +3: ClienteService.obtenerClientePorId con BD real debe obtener un cliente por ID cuando existe [en BD real]
00:05 +4: ClienteService.obtenerClientePorId con BD real debe devolver null cuando el ID no existe [en BD real]
00:06 +5: ClienteService.buscarPorNombre con BD real debe encontrar clientes que coincidan con el nombre [en BD real]
00:07 +6: ClienteService.buscarPorNombre con BD real debe devolver lista vacia cuando no hay coincidencias [en BD real]
00:09 +7: ClienteService.obtenerFiltrados con BD real debe obtener clientes con paginacion [en BD real]
00:10 +8: ClienteService.obtenerFiltrados con BD real debe obtener solo clientes deudores cuando esDeudor es true [en BD real]
00:11 +9: ClienteService.actualizarCliente con BD real debe actualizar un cliente correctamente [en BD real]
00:12 +10: ClienteService.actualizarCliente con BD real debe lanzar BusinessException cuando el cliente no existe [en BD real]
00:14 +11: ClienteService.eliminarCliente con BD real debe eliminar (desactivar) un cliente correctamente [en BD real]
00:15 +12: ClienteService.eliminarCliente con BD real debe lanzar BusinessException cuando el cliente no existe [en BD real]
00:17 +13: ClienteService.actualizarEstadoDeudor con BD real debe ejecutarse sin errores para un cliente existente [en BD real]
00:17 +13: (tearDownAll)
00:17 +13: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 13 |
| Exitosas | 13 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Creacion | 2 | 2 |
| Consulta | 4 | 4 |
| Busqueda | 2 | 2 |
| Actualizacion | 3 | 3 |
| Eliminacion | 2 | 2 |

## 2. Tests Ejecutados

### 2.1. ClienteService (13 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | crearCliente | Crear cliente correctamente con todos los campos | Creacion |
| 2 | crearCliente | Crear cliente sin campos opcionales (dni, email, telefono) | Creacion |
| 3 | obtenerClientePorId | Obtener cliente por ID cuando existe | Consulta |
| 4 | obtenerClientePorId | Devolver null cuando el ID no existe | Consulta |
| 5 | buscarPorNombre | Encontrar clientes que coincidan con el nombre | Busqueda |
| 6 | buscarPorNombre | Devolver lista vacia cuando no hay coincidencias | Busqueda |
| 7 | obtenerFiltrados | Obtener clientes con paginacion | Consulta |
| 8 | obtenerFiltrados | Obtener solo clientes deudores | Consulta |
| 9 | actualizarCliente | Actualizar un cliente correctamente | Actualizacion |
| 10 | actualizarCliente | Lanzar BusinessException cuando el cliente no existe | Actualizacion |
| 11 | eliminarCliente | Eliminar (desactivar) un cliente correctamente | Eliminacion |
| 12 | eliminarCliente | Lanzar BusinessException cuando el cliente no existe | Eliminacion |
| 13 | actualizarEstadoDeudor | Ejecutarse sin errores para un cliente existente | Actualizacion |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path | Validaciones |
|--------|------------|------------|--------------|
| crearCliente | si | no | no |
| obtenerClientePorId | si | si | no |
| buscarPorNombre | si | si | no |
| obtenerFiltrados | si | no | no |
| actualizarCliente | si | si | no |
| eliminarCliente | si | si | no |
| actualizarEstadoDeudor | si | no | no |

## 4. Interpretacion

- **Cobertura total:** 13 tests sobre 7 metodos de ClienteService, cubriendo happy path y error path.
- **Patron verificado:** Flujo completo Service, Repository, PostgreSQL real (Neon rama test). Se validaron tipos de datos (VARCHAR, nullable), busquedas ILIKE, soft delete (es_activo), y paginacion.
- **Limpieza:** Cada test se envuelve en BEGIN/ROLLBACK, los datos creados nunca persisten.
- **Campos opcionales:** Se verifico que dni, email y telefono pueden ser nulos correctamente.
- **Controladores:** No incluidos por ser capas de delegacion fina sin logica de BD propia.

## 5. Conclusiones

El modulo Clients funciona correctamente contra la base de datos real. CRUD completo, busqueda por nombre con ILIKE, paginacion, soft delete, y manejo de deudores. Las excepciones personalizadas se propagan adecuadamente desde el repository hacia el service.
