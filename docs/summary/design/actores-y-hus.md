# Diagrama de Actores y HUs


1. Introducción

El presente documento tiene como propósito describir los requisitos de usuario del sistema

iVenti, el cual será implementado para el negocio Multiservicios Golden. Este documento

deﬁne de manera clara las necesidades del usuario ﬁnal, sirviendo como base para el diseño

y desarrollo del sistema. Asimismo, se detallan los requisitos desde la perspectiva del usuario

ﬁnal, sin entrar aún en especiﬁcaciones técnicas.

El sistema iVenti cubrirá las siguientes funcionalidades a nivel de usuario:

●  Gestión de inventario (registro, actualización, eliminación y consulta de productos)
●  Registro y control de ventas
●  Gestión de clientes con deudas
●  Generación de reportes
●  Escaneo de códigos de barras
●  Notiﬁcaciones de stock bajo y productos próximos a vencer
●  Respaldo de información en la nube

El sistema será utilizado principalmente por la propietaria del negocio.

●  BRS - Business Requirements Speciﬁcation
●  CRUD - Crear, Leer, Actualizar y Eliminar
●  RF - Requisito Funcional
●  RNF - Requisito No Funcional
●  Stock - Cantidad disponible de un producto
●  Nube - Servicio remoto para almacenamiento de datos
●  Escáner - Dispositivo o funcionalidad para leer códigos de barras

2. Descripción General del Sistema

El sistema iVenti forma parte del proceso de digitalización del negocio Multiservicios Golden,

permitiendo reemplazar el control manual por un sistema automatizado de inventario y

ventas.

El sistema se integra con servicios externos de almacenamiento en la nube para el respaldo y

recuperación de datos, garantizando la disponibilidad y seguridad de la información.

Usuario principal (Propietaria)
Encargada de gestionar todas las operaciones del sistema, como gestionar el inventario,

registrar ventas, administrar deudas y generar reportes.

Sistema externo (Servicios en la nube)
Responsable del almacenamiento y recuperación de la información respaldada.

Dispositivo de escaneo
Permite registrar productos mediante la lectura de códigos de barras.

Dispositivo: Tablet o dispositivo móvil

Conectividad:

●  Funciona oﬄine para operaciones principales
●  Requiere internet para respaldo en la nube

Lugar: Tienda física Multiservicios Golden

Nivel de experiencia: Usuario con conocimientos básicos de tecnología

3. Stakeholders y Usuarios

●  Propietaria del negocio (usuario principal)
●  Clientes del negocio (son afectados indirectamente)
●  Equipo de desarrollo
●  Servicios de almacenamiento en la nube

Usuario principal

●  Edad: Adulto
●  Experiencia tecnológica: Básica
●  Necesidad principal: Simplicidad y rapidez
●  Frecuencia de uso: Alta (uso diario)

●  Tener control claro del inventario
●  Registrar ventas ya sea al contado o al crédito
●  Reducir errores en las transacciones
●  Acceder rápidamente a información
●  Evitar pérdidas por productos vencidos
●  Mantener respaldo seguro de los datos
●  Obtener reportes para toma de decisiones

4. Escenarios de Uso

Escenario 1: Registrar una venta

El usuario registra una venta seleccionando productos, indicando cantidades y el tipo de

pago (contado o crédito). El sistema calcula el total, valida el stock disponible, actualiza el

inventario, genera la boleta si corresponde y registra la operación.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión en el sistema
○  Existen productos registrados en el inventario
○  Los productos cuentan con stock disponible

●  Postcondiciones

○  La venta queda registrada en el sistema
○  El inventario se actualiza automáticamente
○  Se genera una boleta si el monto es mayor a 5 soles
○  Si la venta es a crédito, se registra la deuda del cliente

Escenario 2: Registrar producto

El usuario registra un nuevo producto ingresando sus datos manualmente o mediante el

escaneo de código de barras. El sistema valida la información y guarda el producto en el

inventario.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión

●  Postcondiciones:

○  El producto queda registrado en el inventario
○  El producto está disponible para ser utilizado en ventas

Escenario 3: Actualizar producto

El usuario selecciona un producto existente y modiﬁca su información. El sistema valida los

datos y guarda los cambios en el inventario.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión en el sistema
○  Existen productos registrados en el inventario

●  Postcondiciones:

○  La información del producto se actualiza correctamente
○  Los cambios se reﬂejan en el inventario

Escenario 4: Desactivar producto

El usuario selecciona un producto y cambia su estado a inactivo para evitar su uso en nuevas

ventas, manteniendo su información en el sistema.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión en el sistema
○  Existen productos registrados en el inventario
○  El producto se encuentra activo

●  Postcondiciones:

○  El producto queda marcado como inactivo
○  El producto no está disponible para nuevas ventas
○  El historial del producto se mantiene en el sistema

Escenario 5: Consultar inventario

El usuario accede al inventario para visualizar los productos registrados, pudiendo buscar,

ﬁltrar y revisar su estado y disponibilidad.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión en el sistema
○  Existen productos registrados en el inventario

●  Postcondiciones:

○  Se muestra la información actualizada del inventario
○  El usuario puede identiﬁcar productos disponibles, inactivos, con bajo stock o

próximos a vencer

Escenario 6: Gestión de deudas

El usuario accede al módulo de deudas para visualizar y controlar las deudas de los clientes,

consultando su estado, monto pendiente y detalle de ventas asociadas.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión en el sistema
○  Existen ventas registradas a crédito

●  Postcondiciones:

○  Se muestra la información actualizada de las deudas
○  El usuario puede identiﬁcar deudas pendientes y pagadas
○  Se mantiene el historial de deudas en el sistema

Escenario 7: Registrar pago de deuda

El usuario registra el pago de una deuda de un cliente, ya sea de forma total o parcial. El

sistema valida el monto ingresado y actualiza el estado de la deuda.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión en el sistema
○  Existe al menos una deuda pendiente registrada

●  Postcondiciones:

○  La deuda se actualiza con el nuevo monto pagado
○  Se reduce el saldo pendiente o se marca como pagada
○  Se registra el pago en el sistema con su fecha

Escenario 8: Generar reportes

El usuario genera reportes de ventas o inventario seleccionando el tipo de reporte y, si aplica,

un rango de fechas. El sistema procesa la información y presenta el reporte en formato

digital.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión en el sistema
○  Existen datos registrados en el sistema (ventas y/o inventario)

●  Postcondiciones:

○  El reporte se genera correctamente
○  El usuario puede visualizar el reporte
○  El usuario puede exportar el reporte en formato PDF

Flujo: Registrar venta

Flujo: Registrar venta

1.  El usuario inicia una nueva venta
2.  Selecciona productos o los escanea
3.
Ingresa cantidades
4.  El sistema valida el stock
5.  El sistema calcula el total

6.  El usuario selecciona tipo de pago
7.  El usuario conﬁrma la venta
8.  El sistema registra la venta
9.  El sistema actualiza el inventario
10.  El sistema genera boleta (si aplica)
11.  El sistema muestra conﬁrmación

Flujo: Registrar producto

1.  El usuario inicia el registro de producto
2.  El usuario ingresa los datos del producto o escanea el código de barras
3.  El sistema valida que los datos sean correctos
4.  El usuario conﬁrma el registro
5.  El sistema guarda el producto en el inventario
6.  El sistema muestra un mensaje de conﬁrmación

Flujo: Actualizar producto

1.  El usuario accede al inventario
2.  El usuario selecciona un producto
3.  El sistema muestra la información actual del producto
4.  El usuario modiﬁca uno o más datos
5.  El sistema valida la información ingresada
6.  El usuario conﬁrma la actualización
7.  El sistema guarda los cambios
8.  El sistema muestra un mensaje de conﬁrmación

Flujo: Desactivar producto

1.  El usuario accede al inventario
2.  El usuario selecciona un producto activo
3.  El usuario elige la opción de desactivar
4.  El sistema cambia el estado del producto a inactivo
5.  El sistema actualiza el inventario
6.  El sistema muestra un mensaje de conﬁrmación

Flujo: Consultar inventario

1.  El usuario accede al módulo de inventario
2.  El sistema muestra la lista de productos
3.  El usuario puede buscar productos por nombre
4.  El usuario puede aplicar ﬁltros (categoría, estado, stock)
5.  El sistema actualiza la vista según los ﬁltros aplicados

6.  El usuario visualiza la información detallada de los productos

Flujo: Gestión de deudas

1.  El usuario accede al módulo de deudas
2.  El sistema muestra la lista de clientes con deudas
3.  El sistema muestra el monto total adeudado por cada cliente
4.  El usuario selecciona un cliente
5.  El sistema muestra el detalle de las deudas (ventas asociadas, montos, estado)
6.  El usuario revisa la información

Flujo: Registrar pago de deuda

1.  El usuario accede al módulo de deudas
2.  El usuario selecciona un cliente con deuda
3.  El sistema muestra el monto pendiente
4.  El usuario ingresa el monto a pagar
5.  El sistema valida que el monto sea válido
6.  El usuario conﬁrma el pago
7.  El sistema actualiza la deuda
8.  El sistema muestra un mensaje de conﬁrmación

Flujo: Generar reportes

1.  El usuario accede al módulo de reportes
2.  El usuario selecciona el tipo de reporte (ventas o inventario)
3.  El usuario deﬁne un rango de fechas (para reportes de ventas)
4.  El sistema procesa la información
5.  El sistema genera el reporte
6.  El sistema muestra el reporte al usuario
7.  El usuario puede exportar el reporte en PDF

5. Requisitos de Usuario

●  El usuario puede registrar ventas
●  El usuario puede registrar ventas al contado o crédito
●  El sistema permite gestionar el inventario (CRUD: crear, consultar, actualizar, eliminar

productos)

●  El sistema permite generar boletas de venta
●  El sistema permite gestionar clientes con deudas
●  El sistema permite generar reportes de ventas e inventario
●  El sistema permite escanear productos mediante código de barras
●  El sistema notiﬁca productos con stock bajo o próximos a vencer
●  El sistema permite respaldar y recuperar información en la nube

●  El sistema debe ser fácil de usar e intuitivo
●  El sistema debe responder en menos de 3 segundos en operaciones comunes
●  El sistema debe funcionar sin conexión a internet para operaciones principales
●  El sistema debe garantizar la seguridad de la información
●  El sistema debe ser compatible con dispositivos móviles

6. Modelado de Interacción

Actores identiﬁcados:

●  Usuario (Propietaria)
●  Servicio en la nube
●  Dispositivo de escaneo
●  Cliente (actor indirecto)

HU: Registrar productos

YO

Como Usuario

QUIERO

Registrar productos en el inventario

PARA

Tener control de los productos disponibles

CRITERIOS DE ACEPTACIÓN

●  El usuario puede ingresar los datos del producto (nombre, categoría, precio,

cantidad, fecha de vencimiento si aplica)

●  El usuario puede registrar productos manualmente o mediante escaneo de código

de barras

●  El sistema debe validar que los campos obligatorios estén completos antes de

guardar

●  El sistema no debe permitir registrar productos con datos inválidos (precio

negativo, cantidad negativa, etc.)

●  El sistema debe guardar el producto en el inventario correctamente
●  El sistema debe permitir visualizar el producto registrado en la lista de inventario
●  El sistema debe asignar un identiﬁcador único al producto

HU: Actualizar productos

YO

Como Usuario

QUIERO

Actualizar la información de un producto

PARA

Mantener los datos del inventario correctos y actualizados

CRITERIOS DE ACEPTACIÓN

●  El usuario puede seleccionar un producto existente del inventario
●  El sistema debe mostrar la información actual del producto seleccionado
●  El usuario puede modiﬁcar uno o más campos (nombre, categoría, precio, cantidad,

fecha de vencimiento)

●  El sistema debe validar que los datos ingresados sean correctos (no valores

negativos, campos obligatorios completos)

●  El sistema debe guardar los cambios correctamente
●  El sistema debe reﬂejar los cambios actualizados en el inventario
●  El sistema debe mantener el mismo identiﬁcador del producto (no crear uno nuevo)

HU: Desactivar productos

YO

Como Usuario

QUIERO

Desactivar un producto del inventario

PARA

Evitar su uso en nuevas ventas sin perder su historial

CRITERIOS DE ACEPTACIÓN

●  El usuario puede seleccionar un producto activo del inventario
●  El sistema debe permitir cambiar el estado del producto a “inactivo”
●  El producto inactivo no debe aparecer disponible para nuevas ventas
●  El producto inactivo debe mantenerse registrado en el sistema
●  El producto debe seguir apareciendo en reportes y ventas históricas
●  El sistema debe permitir visualizar productos activos e inactivos

●  El usuario puede volver a activar un producto si es necesario

HU: Consultar inventario

YO

Como Usuario

QUIERO

Consultar el inventario de productos

PARA

Conocer la disponibilidad y estado de los productos

CRITERIOS DE ACEPTACIÓN

●  El sistema debe mostrar una lista de productos registrados en el inventario
●  El usuario puede visualizar información de cada producto (nombre, categoría,

precio, cantidad, estado, fecha de vencimiento si aplica)

●  El usuario puede buscar productos por nombre
●  El usuario puede ﬁltrar productos por categoría
●  El usuario puede ﬁltrar productos por estado (activos e inactivos)
●  El sistema debe permitir identiﬁcar productos con bajo stock
●  El sistema debe permitir identiﬁcar productos próximos a vencer
●  El sistema debe mostrar la información de forma clara y organizada

HU: Gestión de deudas

YO

Como Usuario

QUIERO

Gestionar las deudas de mis clientes

PARA

Llevar un control claro de los pagos pendientes y su estado

CRITERIOS DE ACEPTACIÓN

●  El sistema debe mostrar una lista de clientes con deudas registradas
●  El usuario puede visualizar el monto total de deuda por cada cliente
●  El usuario puede ver el detalle de las ventas asociadas a cada deuda
●  El sistema debe indicar el estado de cada deuda (pendiente o pagada)
●  El usuario puede seleccionar un cliente para ver información detallada
●  El sistema debe permitir identiﬁcar fácilmente las deudas pendientes
●  El sistema debe actualizar automáticamente la información cuando se registran

pagos

●  El sistema debe mantener el historial de deudas, incluso si ya fueron pagadas

HU: Generar reportes

YO

Como Usuario

QUIERO

Generar reportes de ventas e inventario

PARA

Analizar el estado del negocio y tomar decisiones informadas

CRITERIOS DE ACEPTACIÓN

●  El usuario puede seleccionar el tipo de reporte (ventas o inventario)
●  El usuario puede deﬁnir un rango de fechas para los reportes de ventas
●  El sistema debe generar un reporte de ventas con detalle de productos vendidos,

cantidades, fechas y montos

●  El sistema debe generar un reporte de inventario con el estado actual de los

productos (stock, estado, vencimiento)

●  El sistema debe permitir identiﬁcar productos con bajo stock en los reportes
●  El sistema debe permitir identiﬁcar productos próximos a vencer
●  El sistema debe mostrar un resumen de información (totales de ventas, productos

más vendidos, etc.)

●  El sistema debe permitir exportar los reportes en formato PDF
●  El sistema debe generar los reportes en un tiempo razonable
