# Lista de Observaciones

UNIVERSIDAD NACIONAL MAYOR DE SAN MARCOS
UNIVERSIDAD DEL PERÚ, DECANA DE AMÉRICA
FACULTAD DE INGENIERÍA DE SISTEMAS E INFORMÁTICA

**Alumnos:**
- Castilla Huanca, Marco Renato
- Basualdo Ale, Marcos Luis
- Poma Gutierrez, Gabriel

**Curso:** Aseguramiento de la Calidad de Software
**Profesor:** Mario Huapaya Chumpitaz

**2026**

## Introducción

El presente reporte detalla los resultados obtenidos tras la ejecución de los casos de prueba, tanto de caja negra como de caja blanca, aplicados al sistema iVenti. El objetivo fundamental de estas pruebas es asegurar la funcionalidad, robustez y calidad del software, validando los escenarios de usuario y la integridad de la lógica interna mediante pruebas unitarias automatizadas. A continuación, se presentan los hallazgos identificados, las evidencias correspondientes y el estado actual del sistema.

## Reporte de Resultados de Casos de Prueba (Caja Negra) - iVenti

### CP-01 — Inicio de sesión con PIN correcto

| Atributo | Descripción |
|---|---|
| **Escenario relacionado** | ESC-01 (Set SD-01) |
| **Tipo / Técnica** | Funcional / Caja negra |
| **Objetivo** | Verificar que el sistema concede el acceso con un PIN válido. |
| **Precondiciones** | Usuario registrado con PIN "010101" |
| **Datos de entrada** | PIN ingresado = "010101" |
| **Pasos** | 1. Abrir la aplicación iVenti. 2. Ingresar el PIN "123456". 3. Confirmar. |
| **Resultado esperado** | El acceso es concedido y el sistema muestra el menú principal. |
| **Resultado obtenido** | Efectivamente el acceso es concedido y se muestra la pantalla del menú principal. |
| **Estado** | Pasó |

### CP-02 — Inicio de sesión con PIN incorrecto

| Atributo | Descripción |
|---|---|
| **Escenario relacionado** | ESC-01 (Set SD-01) |
| **Tipo / Técnica** | Funcional / Caja negra |
| **Objetivo** | Verificar que el sistema rechaza un PIN inválido. |
| **Precondiciones** | Usuario registrado con PIN "123456". |
| **Datos de entrada** | PIN ingresado = "999999". |
| **Pasos** | 1. Abrir la aplicación iVenti. 2. Ingresar el PIN "999999". 3. Confirmar. |
| **Resultado esperado** | El acceso es denegado; se muestra un mensaje de error y no se ingresa al sistema. |
| **Resultado obtenido** | El acceso es denegado; se muestra un mensaje que detalla el error y no se ingresa al sistema como está previsto. |
| **Estado** | Pasó |

### CP-03 — Registro de producto válido

| Atributo | Descripción |
|---|---|
| **Escenario relacionado** | ESC-02 (Set SD-02) |
| **Tipo / Técnica** | Funcional / Caja negra |
| **Objetivo** | Verificar el registro correcto de un producto con todos sus datos. |
| **Precondiciones** | Sesión iniciada. |
| **Datos de entrada** | nombre="Coca Cola 500ml", precio=3.50, stock=24, código="7501055300013". |
| **Pasos** | 1. Ir al módulo Productos. 2. Seleccionar Nuevo. 3. Llenar los datos del producto. 4. Guardar. |
| **Resultado esperado** | El producto queda registrado y visible en la lista, asociado a su código de barras. |
| **Resultado obtenido** | El producto queda registrado y visible en la sección "Inventario", asociado a su código de barras. |
| **Estado** | Pasó |

### CP-04 — Registro de producto con campo obligatorio vacío

| Atributo | Descripción |
|---|---|
| **Escenario relacionado** | ESC-02 (Set SD-02) |
| **Tipo / Técnica** | Funcional / Caja negra |
| **Objetivo** | Verificar la validación de campos obligatorios. |
| **Precondiciones** | Sesión iniciada. |
| **Datos de entrada** | nombre="" (vacío), precio=3.50 |
| **Pasos** | 1. Ir a Nuevo producto. 2. Dejar el nombre vacío. 3. Guardar. |
| **Resultado esperado** | El sistema muestra un error de campo obligatorio y no guarda el producto. |
| **Resultado obtenido** | El sistema muestra un error de campo obligatorio "Nombre requerido" y no guarda el producto. |
| **Estado** | Pasó |

### CP-05 — Salida de stock mayor al disponible

| Atributo | Descripción |
|---|---|
| **Escenario relacionado** | ESC-03 (Set SD-03) |
| **Tipo / Técnica** | Funcional / Caja negra |
| **Objetivo** | Verificar que no se permite dejar el stock en negativo. |
| **Precondiciones** | Producto "Coca Cola 500ml" con stock 5. |
| **Datos de entrada** | Cantidad de salida solicitada 8. |
| **Pasos** | 1. Registrar una salida de 8 unidades. 2. Confirmar. |
| **Resultado esperado** | El sistema rechaza la operación; el stock se mantiene en 5 y no queda en negativo. |
| **Resultado obtenido** | El sistema rechaza la operación; el stock se mantiene en 5 y no queda en negativo como está previsto. |
| **Estado** | Pasó |

### CP-06 — Escaneo de código de barras

| Atributo | Descripción |
|---|---|
| **Escenario relacionado** | ESC-04 (Set SD-04) |
| **Tipo / Técnica** | Funcional / Caja negra |
| **Objetivo** | Verificar que el escaneo ubica el producto correcto. |
| **Precondiciones** | Cámara disponible; producto con el código registrado. |
| **Datos de entrada** | Código "7501055300013". |
| **Pasos** | 1. Abrir el escáner. 2. Escanear el código de barras. |
| **Resultado esperado** | El sistema carga el producto asociado al código escaneado. |
| **Resultado obtenido** | El sistema procesó el código pero no mostró los datos esperados haciendo un retroceso automático instantáneo a la sección de "Inventario". |
| **Estado** | Falló |

### CP-07 — Venta al contado

| Atributo | Descripción |
|---|---|
| **Escenario relacionado** | ESC-05 (Set SD-05) |
| **Tipo / Técnica** | Funcional / Caja negra |
| **Objetivo** | Verificar el registro de una venta al contado y la emisión de boleta. |
| **Precondiciones** | Productos con stock disponible. |
| **Datos de entrada** | 2x Coca Cola (3.50) + 1 x Galleta (1.20); recibido=10.00. |
| **Pasos** | 1. Agregar los productos al carrito. 2. Seleccionar pago al contado. 3. Confirmar la venta. |
| **Resultado esperado** | La venta se registra, el stock se descuenta, se genera la boleta con su código y se calcula el vuelto (1.80). |
| **Resultado obtenido** | Salto de error con los lotes de la base de datos |
| **Estado** | Falló |

### CP-08 — Venta a crédito con registro de deuda

| Atributo | Descripción |
|---|---|
| **Escenario relacionado** | ESC-06 (Set SD-06) |
| **Tipo / Técnica** | Funcional / Caja negra |
| **Objetivo** | Verificar que una venta a crédito genera la deuda asociada al cliente. |
| **Precondiciones** | Cliente "Juan Pérez" registrado. |
| **Datos de entrada** | 3x producto a 50.00; modalidad=crédito; abono=0. |
| **Pasos** | 1. Agregar el producto al carrito. 2. Seleccionar pago a crédito. 3. Asignar al cliente Juan Pérez. 4. Confirmar. |
| **Resultado esperado** | La venta se registra y se asocia una deuda de 150.00 al cliente Juan Pérez. |
| **Resultado obtenido** | Error en conexión con la base de datos |
| **Estado** | Falló |

### CP-09 — Pago parcial de deuda

| Atributo | Descripción |
|---|---|
| **Escenario relacionado** | ESC-07 (Set SD-07) |
| **Tipo / Técnica** | Funcional / Caja negra |
| **Objetivo** | Verificar la actualización del saldo tras un abono parcial. |
| **Precondiciones** | Cliente "Juan Pérez" con deuda 150.00. |
| **Datos de entrada** | Monto del abono = 40.00. |
| **Pasos** | 1. Ir a las deudas del cliente. 2. Registrar un pago de 40.00. 3. Confirmar. |
| **Resultado esperado** | El saldo de la deuda se actualiza a 110.00. |
| **Resultado obtenido** | Mensaje de error: no se pudo actualizar el pago |
| **Estado** | Falló |

## Reporte de Resultados de Casos de Prueba (Caja Blanca) - iVenti

### 1. Información General del Entorno de Pruebas

- **Fecha de Ejecución:** 16 de Junio de 2026
- **Herramienta de Pruebas:** Flutter Test Framework (Dart Unit Testing)
- **SDK de Flutter:** v3.32.0 (Dart v3.8.0)
- **Ficheros de Configuración:** .env.test con clave AES de 256 bits (Base64)
- **Resultado General:** Aprobado (100% de éxito en 280 pruebas unitarias)

### 2. Resumen Ejecutivo de Casos de Prueba

| ID | Descripción del Escenario | Estado Esperado | Resultado de Ejecución | Estado Final |
|---|---|---|---|---|
| CP-10 | Cálculo de deuda al realizar venta a crédito | Total = 150.00; Deuda = 150.00 | El cálculo del monto total y crédito en base a cantidades y precios unitarios fue verificado correctamente. | PASÓ |
| CP-11 | Validación de stock no negativo (Insuficiente) | Lanzamiento de excepción | Se validó que una venta que excede el stock físico lanza un BusinessException bloqueando la operación. | PASÓ |
| CP-12 | Cifrado y verificación de PIN (HMAC-SHA256) | Coincidencia de hash determinista | Se comprobó la integridad del hash HMAC-SHA256, su carácter determinista y la validación correcta. | PASÓ |
| CP-13 | Cálculo de saldo restante tras pago parcial | Saldo = 110.00 | El sistema valida que el abono se reste del saldo y prohíbe pagos que excedan la deuda. | PASÓ |

### 3. Detalle Técnico de los Resultados

#### CP-10 — Cálculo de deuda en venta a crédito

- **Escenario de Prueba (ESC-06):** Compras con abono cero y validación de totales.
- **Prueba Asignada:** `debe crear venta correctamente` en `venta_service_test.dart`
- **Resultados de Verificación:**
  - Monto total calculado: $150.00 (Precio unitario $50.00 × Cantidad 3).
  - Estado de crédito asignado: `true`.
  - Validaciones de tipo de datos superadas.

#### CP-11 — Validación de stock no negativo

- **Escenario de Prueba (ESC-03):** Intento de compra de 8 unidades cuando solo se dispone de 5 unidades.
- **Prueba Asignada:** `debe lanzar BusinessException cuando stock insuficiente` en `venta_service_test.dart`
- **Resultados de Verificación:**
  - Intento de procesar cantidad = 5 con cantidadActual = 1 en lote.
  - La transacción fue interceptada en `VentaService.crearVenta()`.
  - Se lanzó de forma correcta el error `BusinessException` con el mensaje descriptivo "Stock insuficiente".

#### CP-12 — Verificación de PIN con HMAC-SHA256

- **Escenario de Prueba (ESC-01):** Cifrado determinístico y comparación de firmas HMAC.
- **Pruebas Asignadas:**
  - mismo PIN + misma key produce mismo hash
  - diferentes PINs producen diferente hash
  - hash es determinista con la misma `ENCRYPTION_KEY`
  - Ubicación: `pin_encryptor_test.dart`
- **Resultados de Verificación:**
  - Validación correcta del algoritmo HMAC-SHA256.
  - Confirmación de firma con longitud exacta de 64 caracteres hexadecimales.

#### CP-13 — Cálculo de saldo tras pago parcial

- **Escenario de Prueba (ESC-07):** Abono parcial de $40.00 sobre deuda de $150.00, esperando saldo de $110.00.
- **Pruebas Asignadas:**
  - `debe registrar pago correctamente`
  - `debe lanzar BusinessException cuando monto excede saldo pendiente`
  - Ubicación: `pago_service_test.dart`
- **Resultados de Verificación:**
  - Un abono parcial de $50.00 sobre una deuda de $100.00 dejó un saldo pendiente remanente de $50.00 de manera exitosa.
  - Un abono de $50.00 sobre una deuda con saldo pendiente de $40.00 gatilló correctamente una excepción por excedente.

## Conclusión

En conclusión, el proceso de pruebas ha permitido identificar discrepancias críticas en la integración del sistema iVenti que afectan la funcionalidad en tiempo real, a pesar de que la lógica interna y las pruebas unitarias muestran un rendimiento óptimo. Se recomienda priorizar la corrección de los errores detectados en la base de datos y la integración de las interfaces para garantizar la estabilidad operativa del sistema.
