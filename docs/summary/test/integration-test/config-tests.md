# Config - Pruebas de Integracion

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: loading test/integration-test/config/config_integration_test.dart
00:00 +0: (setUpAll)
00:01 +0: guardarConfiguracion debe crear una configuracion correctamente [en BD real]
00:02 +1: guardarConfiguracion debe actualizar una configuracion existente [en BD real]
00:03 +2: obtenerConfiguracion debe devolver null cuando la clave no existe [en BD real]
00:04 +3: eliminarConfiguracion debe lanzar NotFoundException cuando no existe [en BD real]
00:05 +4: (tearDownAll)
00:05 +4: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 4 |
| Exitosas | 4 |
| Fallidas | 0 |

## 2. Tests Ejecutados

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | guardarConfiguracion | Crear una configuracion correctamente | Creacion |
| 2 | guardarConfiguracion | Actualizar una configuracion existente (upsert) | Actualizacion |
| 3 | obtenerConfiguracion | Devolver null cuando la clave no existe | Consulta |
| 4 | eliminarConfiguracion | Lanzar NotFoundException cuando no existe | Error path |

## 3. Metodos Evaluados

| Metodo | Happy Path | Error Path |
|--------|------------|------------|
| guardarConfiguracion | si | no |
| obtenerConfiguracion | no | si |
| eliminarConfiguracion | no | si |

## 4. Interpretacion

- **Cobertura total:** 4 tests sobre 3 metodos de ConfiguracionService.
- **Upsert verificado:** `INSERT ... ON CONFLICT DO UPDATE` funciona correctamente, actualizando el mismo registro en lugar de crear duplicados.
- **NotFoundException:** `eliminarConfiguracion` lanza `NotFoundException`, no `BusinessException`, porque el repositorio la lanza directamente y el servicio no la captura.

## 5. Conclusiones

El modulo Config funciona correctamente contra la base de datos real. El upsert de configuraciones se comporta segun lo esperado y la eliminacion notifica correctamente cuando el recurso no existe.
