# Diccionario de Datos

1. Introducción

El presente documento tiene como propósito describir la estructura física de la base de datos
del sistema iVenti, detallando las tablas, atributos, relaciones y reglas de integridad. Este
diccionario permite comprender cómo se organiza y almacena la información dentro del
sistema, facilitando su análisis, mantenimiento y escalabilidad.

El documento abarca el modelo de datos físico implementado en la base de datos
PostgreSQL del sistema iVenti. Incluye la definición de tablas, relaciones entre entidades,
restricciones de integridad y consideraciones de persistencia de datos. No se incluyen
aspectos de implementación a nivel de código de aplicación.

● Documento de Especificación de Requisitos de Software (SRS) del sistema iVenti
● Documento de Arquitectura de Software del sistema iVenti
● Modelo Físico de Datos del sistema iVenti
● PostgreSQL Documentation (versión utilizada en el proyecto)
2. Descripción General de Datos

El sistema iVenti gestiona información relacionada con inventario, ventas, clientes, usuarios,
proveedores y transacciones comerciales. Los datos son almacenados en una base de datos
relacional PostgreSQL, permitiendo la integridad y consistencia de la información mediante
relaciones entre tablas.

● Las claves primarias se identifican como id_*
● Las claves foráneas mantienen relación directa con otras tablas
● Los valores booleanos representan estados activos/inactivos o condiciones del
negocio
● Los campos TIMESTAMP almacenan fechas y horas de eventos
● Los campos monetarios utilizan tipo NUMERIC(10,2) para precisión financiera

3. Modelo de Datos Físico

A continuación, se presenta el modelo físico de la base de datos del sistema iVenti, el cual representa las tablas, atributos y relaciones
implementadas en PostgreSQL.

4. Definición de Tablas

Descripción: Almacena los roles disponibles dentro del sistema.

| Campo   | Tipo    | Descripción                  | Restricciones  |
| ------- | ------- | ---------------------------- | -------------- |
| id_rol  | SERIAL  | Identificador único del rol  | PK             |

| nombre  | VARCHAR(15)  | Nombre del rol  | NOT NULL, UNIQUE   |
| ------- | ------------ | --------------- | ------------------ |

Descripción: Almacena la información de los usuarios del sistema.

| Campo       | Tipo          | Descripción              | Restricciones  |
| ----------- | ------------- | ------------------------ | -------------- |
| id_usuario  | SERIAL        | Identificador único del  | PK             |

| id_rol      | INTEGER       | Rol asignado al usuario  | FK, NOT NULL   |
| nombre      | VARCHAR(15)   | Nombre del usuario       | NOT NULL       |
contraseña   VARCHAR(6)   PIN de acceso del usuario   NOT NULL
email  VARCHAR(120)  Correo electrónico del  NOT NULL, UNIQUE
usuario

Descripción: Almacena la información de los clientes del negocio.

| Campo              | Tipo          | Descripción              | Restricciones  |
| ------------------ | ------------- | ------------------------ | -------------- |
| id_cliente         | SERIAL        | Identificador único del  | PK             |

| dni                | VARCHAR(8)    | Documento de identidad   | UNIQUE         |
| nombres            | VARCHAR(50)   | Nombres del cliente      |                |
| apellido_paterno   | VARCHAR(25)   | Apellido paterno         |                |
| apellido_materno   | VARCHAR(25)   | Apellido materno         |                |

| email   | VARCHAR(120)   | Correo electrónico   |     |
| ------- | -------------- | -------------------- | --- |
es_deudor   BOOLEAN   Indica si tiene deuda   DEFAULT FALSE

Descripción: Define las unidades de medida de los productos.

| Campo      | Tipo     | Descripción              | Restricciones  |
| ---------- | -------- | ------------------------ | -------------- |
| id_unidad  | SERIAL   | Identificador único del  | PK             |

nombre   VARCHAR(15)   Nombre de la unidad   NOT NULL, UNIQUE
abreviatura   VARCHAR(5)   Abreviatura de la unidad   NOT NULL, UNIQUE

Descripción: Representa los productos disponibles en el inventario.

| Campo         | Tipo      | Descripción                  | Restricciones  |
| ------------- | --------- | ---------------------------- | -------------- |
| id_producto   | SERIAL    | Identificador del producto   | PK             |
| id_unidad     | INTEGER   | Unidad de medida del         | FK, NOT NULL   |
producto
codigo   VARCHAR(15)   Código de barras del  NOT NULL, UNIQUE
producto
nombre   VARCHAR(150)   Nombre del producto  NOT NULL, UNIQUE
| precio         | NUMERIC(10,2)   | Precio de venta        | NOT NULL    |
| -------------- | --------------- | ---------------------- | ----------- |
| stock_actual   | INTEGER         | Cantidad disponible    | DEFAULT 0   |
| stock_minimo   | INTEGER         | Nivel mínimo de stock  | DEFAULT 0   |
| stock_maximo   | INTEGER         | Nivel máximo de stock  |             |
creado_en   TIMESTAMP   Fecha de creación  NOT NULL, DEFAULT
CURRENT_TIMESTAMP
actualizado_en   TIMESTAMP   Fecha de actualización  NOT NULL, DEFAULT
CURRENT_TIMESTAMP
| ruta_imagen   | VARCHAR(35)   | Ruta de la imagen del  |     |
| ------------- | ------------- | ---------------------- | --- |
producto

| es_activo   |     | BOOLEAN   |     | Estado del producto  |     | DEFAULT TRUE  |
| ----------- | --- | --------- | --- | -------------------- | --- | ------------- |

Descripción: Almacena las categorías de productos.

| -------------- | ------ | -------- | ----- | ---------------------------- | ------------ | -------------- |
| id_categoria   |        | SERIAL   |       | Identificador de categoría   |              | PK             |
nombre   VARCHAR(50)   Identificador de categoría   NOT NULL, UNIQUE
es_activo   BOOLEAN   Estado de la categoría   DEFAULT TRUE

Descripción: Registra las transacciones de venta realizadas.

| ----------- | ------ | --------- | ----- | --------------------------- | ------------ | -------------- |
| id_venta    |        | SERIAL    |       | Identificador de la venta   |              | PK             |
| id_cliente  |        | INTEGER   |       | Cliente asociado            |              | FK, NOT NULL   |
id_usuario   INTEGER   Usuario que realiza la venta   FK, NOT NULL
vendido_en   TIMESTAMP   Fecha y hora de la venta   NOT NULL, DEFAULT
CURRENT_TIMESTAMP
| monto_total       |     | NUMERIC(10,2)   |     | Total de la venta   |     | NOT NULL   |
| ----------------- | --- | --------------- | --- | ------------------- | --- | ---------- |
| monto_cancelado   |     | NUMERIC(10,2)   |     | Monto pagado        |     | NOT NULL   |
es_credito   BOOLEAN   Indica si es venta a crédito   DEFAULT FALSE
es_reembolsado   BOOLEAN   Indica si fue reembolsada   DEFAULT FALSE
es_cancelado   BOOLEAN   Indica si fue pagada   DEFAULT TRUE

Descripción: Representa los lotes de productos con control de stock y vencimiento.

| ------------- | ------ | --------- | ----- | ------------------------ | ------------ | -------------- |
| id_lote       |        | SERIAL    |       | Identificador del lote   |              | PK             |
| id_producto   |        | INTEGER   |       | Producto asociado        |              | FK, NOT NULL   |

| cantidad_actual     | INTEGER   | Cantidad disponible   | NOT NULL    |
| ------------------- | --------- | --------------------- | ----------- |
| cantidad_comprada   | INTEGER   | Cantidad inicial      | NOT NULL    |
| cantidad_perdida    | INTEGER   | Cantidad perdida      | DEFAULT 0   |
precio_compra   NUMERIC(10,2)   Precio total de compra   NOT NULL
precio_unitario_compra   NUMERIC(10,2)   Precio unitario   NOT NULL
| fecha_vencimiento   | DATE   | Fecha de vencimiento   |                    |
| ------------------- | ------ | ---------------------- | ------------------ |
| fecha_compra        | DATE   | Fecha de compra        | NOT NULL, DEFAULT  |
CURRENT_DATE
| es_activo   | BOOLEAN   | Estado del lote   | DEFAULT TRUE   |
| ----------- | --------- | ----------------- | -------------- |

Descripción: Representa el detalle de productos vendidos en una venta.

| Campo           | Tipo      | Descripción              | Restricciones  |
| --------------- | --------- | ------------------------ | -------------- |
| id_item_venta   | SERIAL    | Identificador del ítem   | PK             |
| id_venta        | INTEGER   | Venta asociada           | FK, NOT NULL   |
id_lote   INTEGER   Lote del producto vendido   FK, NOT NULL
| cantidad   | INTEGER   | Cantidad vendida   | NOT NULL   |
| ---------- | --------- | ------------------ | ---------- |
precio_unitario   NUMERIC(10,2)   Precio unitario de venta   NOT NULL
| subtotal    | NUMERIC(10,2)   | Subtotal             | NOT NULL    |
| ----------- | --------------- | -------------------- | ----------- |
| descuento   | NUMERIC(10,2)   | Descuento aplicado   | DEFAULT 0   |
| ganancia    | NUMERIC(10,2)   | Ganancia generada    | NOT NULL    |

Descripción: Define los tipos de pago disponibles.

| Campo          | Tipo          | Descripción     | Restricciones      |
| -------------- | ------------- | --------------- | ------------------ |
| id_tipo_pago   | SERIAL        | Identificador   | PK                 |
| nombre         | VARCHAR(15)   | Tipo de pago    | NOT NULL, UNIQUE   |

Descripción: Registra pagos asociados a una venta.

| Campo             | Tipo            | Descripción                | Restricciones  |
| ----------------- | --------------- | -------------------------- | -------------- |
| id_recibo         | SERIAL          | Identificador del recibo   | PK             |
| id_venta          | INTEGER         | Venta asociada             | FK, NOT NULL   |
| id_tipo_pago      | INTEGER         | Tipo de pago               | FK, NOT NULL   |
| monto_cancelado   | NUMERIC(10,2)   | Monto pagado               | NOT NULL       |
monto_pendiente   NUMERIC(10,2)   Monto restante   DEFAULT 0
| pagado_en   | TIMESTAMP   | Fecha de pago   | NOT NULL, DEFAULT  |
| ----------- | ----------- | --------------- | ------------------ |
CURRENT_TIMESTAMP

Descripción: Registra devoluciones de dinero.

| Campo          | Tipo      | Descripción                   | Restricciones  |
| -------------- | --------- | ----------------------------- | -------------- |
| id_reembolso   | SERIAL    | Identificador del reembolso   | PK             |
| id_venta       | INTEGER   | Venta asociada                | FK, NOT NULL   |
id_usuario   INTEGER   Usuario que realiza el  FK, NOT NULL
reembolso
| monto_total   | NUMERIC(10,2)   | Total reembolsado   | NOT NULL   |
| ------------- | --------------- | ------------------- | ---------- |
reembolsado_en   TIMESTAMP   Fecha del reembolso   NOT NULL, DEFAULT
CURRENT_TIMESTAMP

Descripción: Almacena la información de los proveedores del negocio.

| Campo          | Tipo     | Descripción                   | Restricciones  |
| -------------- | -------- | ----------------------------- | -------------- |
| id_proveedor   | SERIAL   | Identificador del proveedor   | PK             |
nombre   VARCHAR(100)   Nombre del proveedor   NOT NULL, UNIQUE

es_activo BOOLEAN Estado del proveedor DEFAULT TRUE

Descripción: Tabla intermedia que representa la relación entre proveedores y productos.
Campo Tipo Descripción Restricciones
id_proveedor INTEGER Proveedor asociado PK, FK, NOT NULL
id_producto INTEGER Proveedor asociado PK, FK, NOT NULL

Descripción: Tabla intermedia que representa la relación entre categorías y productos.
Campo Tipo Descripción Restricciones
id_categoria INTEGER Categoría asociada PK, FK, NOT NULL
id_producto INTEGER Producto asociado PK, FK, NOT NULL

Descripción: Representa el detalle de los productos incluidos en un reembolso.
Campo Tipo Descripción Restricciones
id_item_venta INTEGER Ítem de venta asociado PK, FK, NOT NULL
id_reembolso INTEGER Reembolso asociado PK, FK, NOT NULL
cantidad INTEGER Cantidad reembolsada NOT NULL
subtotal NUMERIC(10,2) Monto parcial del reembolso NOT NULL
5. Relaciones entre Tablas

A continuación, se describen las relaciones existentes entre las tablas del sistema iVenti,
indicando su cardinalidad y propósito dentro del modelo de datos.
Usuario – Rol (N:1)

● Un usuario pertenece a un único rol.
● Un rol puede estar asignado a múltiples usuarios.
● Implementación: Usuario.id_rol → Rol.id_rol
Venta – Usuario (N:1)
● Cada venta es realizada por un usuario.
● Un usuario puede registrar múltiples ventas.
● Implementación: Venta.id_usuario → Usuario.id_usuario
Venta – Cliente (N:1)
● Cada venta está asociada a un cliente.
● Un cliente puede tener múltiples ventas.
● Implementación: Venta.id_cliente → Cliente.id_cliente
Producto – Unidad (N:1)
● Cada producto tiene una unidad de medida.
● Una unidad puede ser utilizada por múltiples productos.
● Implementación: Producto.id_unidad → Unidad.id_unidad
Lote – Producto (N:1)
● Cada lote pertenece a un producto.
● Un producto puede tener múltiples lotes.
● Implementación: Lote.id_producto → Producto.id_producto
ItemVenta – Venta (N:1)
● Cada ítem pertenece a una venta.
● Una venta puede tener múltiples ítems.
● Implementación: ItemVenta.id_venta → Venta.id_venta
ItemVenta – Lote (N:1)
● Cada ítem de venta está asociado a un lote específico.
● Un lote puede participar en múltiples ventas.
● Implementación: ItemVenta.id_lote → Lote.id_lote
Recibo – Venta (N:1)
● Cada recibo está asociado a una venta.
● Una venta puede tener uno o varios registros de pago.

● Implementación: Recibo.id_venta → Venta.id_venta
Recibo – TipoPago (N:1)
● Cada recibo utiliza un tipo de pago.
● Un tipo de pago puede ser utilizado en múltiples recibos.
● Implementación: Recibo.id_tipo_pago → TipoPago.id_tipo_pago
Reembolso – Venta (N:1)
● Cada reembolso está asociado a una venta.
● Una venta puede tener reembolsos asociados.
● Implementación: Reembolso.id_venta → Venta.id_venta
Reembolso – Usuario (N:1)
● Cada reembolso es realizado por un usuario.
● Un usuario puede realizar múltiples reembolsos.
● Implementación: Reembolso.id_usuario → Usuario.id_usuario
Producto – Categoría (resuelta como 1:N + 1:N)
● Un producto puede pertenecer a varias categorías.
● Una categoría puede contener varios productos.
● Implementación: CategoriaProducto.id_producto → Producto.id_producto
CategoriaProducto.id_categoria → Categoria.id_categoria
Producto – Proveedor (resuelta como 1:N + 1:N)
● Un producto puede tener múltiples proveedores.
● Un proveedor puede suministrar múltiples productos.
● Implementación: ProveedorProducto.id_producto → Producto.id_producto
ProveedorProducto.id_proveedor → Proveedor.id_proveedor
ItemVenta – Reembolso (resuelta como 1:N + 1:N)
● Un ítem de venta puede formar parte de un reembolso.
● Un reembolso puede incluir varios ítems.
● Implementación: ItemReembolso.id_item_venta → ItemVenta.id_item_venta
ItemReembolso.id_reembolso → Reembolso.id_reembolso

6. Reglas de Integridad

Todas las relaciones entre tablas están definidas mediante claves foráneas, garantizando la
consistencia de los datos y evitando registros huérfanos.

● Campos únicos como dni, código, nombre en productos y roles
● Campos obligatorios definidos con NOT NULL
● Valores monetarios con precisión decimal
● Estados booleanos para control de activación de registros
7. Consideraciones de Persistencia

El sistema utiliza PostgreSQL como motor de base de datos relacional debido a su robustez,
soporte de relaciones complejas y escalabilidad.

● Uso de claves primarias autoincrementales (SERIAL)
● Normalización de datos para evitar redundancia
● Uso de tablas intermedias para relaciones muchos a muchos
● Separación de datos transaccionales (ventas) y estructurales (productos, categorías)
