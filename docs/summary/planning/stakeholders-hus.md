# Stakeholders y HUs


1. Introducción

El presente documento tiene como propósito describir los requisitos de usuario del sistema

iVenti, el cual será implementado para el negocio Multiservicios Golden. Este documento

deﬁne de manera clara las necesidades del usuario ﬁnal, sirviendo como base para el diseño

y desarrollo del sistema. Asimismo, se detallan los requisitos desde la perspectiva del usuario

ﬁnal, sin entrar aún en especiﬁcaciones técnicas.

La solución propuesta permitirá las siguientes funcionalidades a nivel de usuario:

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

2. Stakeholders y Usuarios

●  Propietaria del negocio (usuario principal): responsable de la gestión del inventario,

registro de ventas y control de deudas.

●  Equipo de desarrollo: encargado de implementar la solución tecnológica en base a

las necesidades del usuario.

Usuario principal: Propietaria del negocio

●  Edad: Adulto
●  Experiencia tecnológica: Básica
●  Frecuencia de uso: Alta (uso diario)
●  Objetivo principal: Registrar ventas y gestionar el inventario de forma rápida y sencilla
●  Problemas actuales:

○  Diﬁcultad para llevar control del inventario
○  Errores en el registro manual de ventas
○  Falta de información para tomar decisiones

●  Mantener un control claro y actualizado del inventario
●  Registrar ventas de forma rápida, tanto al contado como al crédito
●  Reducir errores en las transacciones
●  Acceder de forma rápida a la información del negocio
●  Evitar pérdidas por productos vencidos o con bajo stock
●  Contar con respaldo seguro de la información
●  Obtener reportes que faciliten la toma de decisiones

3. Escenarios de Uso

Escenario 1: Registrar una venta

El usuario registra una venta seleccionando los productos, indicando cantidades y el tipo de

pago (contado o crédito). Luego conﬁrma la operación y obtiene el total de la venta.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión
○  Existen productos disponibles en el inventario

●  Postcondiciones

○  La venta queda registrada
○  El inventario se actualiza
○  En caso de crédito, se registra la deuda del cliente

Escenario 2: Registrar producto

El usuario registra un nuevo producto ingresando sus datos manualmente o mediante

escaneo.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión

●  Postcondiciones:

○  El producto queda disponible en el inventario

Escenario 3: Actualizar producto

El usuario selecciona un producto existente y modiﬁca su información.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión
○  Existen productos registrados

●  Postcondiciones:

○  La información del producto queda actualizada

Escenario 4: Desactivar producto

El usuario cambia el estado de un producto a inactivo para evitar su uso en nuevas ventas.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión
○  El producto está activo

●  Postcondiciones:

○  El producto queda inactivo
○  El producto no se usa en nuevas ventas

Escenario 5: Consultar inventario

El usuario visualiza el inventario y revisa la información de los productos.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión en el sistema
○  Existen productos registrados en el inventario

●  Postcondiciones:

○  Se muestra la información actualizada del inventario
○  El usuario puede identiﬁcar productos disponibles, inactivos, con bajo stock o

próximos a vencer

Escenario 6: Gestión de deudas

El usuario revisa las deudas de los clientes y su estado.

●  Actor Principal: Propietaria
●  Precondiciones:

○  El usuario ha iniciado sesión
○  Existen deudas registradas

●  Postcondiciones:

○  El usuario accede a la información de deudas

Escenario 7: Registrar pago de deuda

El usuario registra un pago realizado por un cliente.

●  Actor Principal: Propietaria
●  Precondiciones:

○  Existe una deuda pendiente

●  Postcondiciones:

○  La deuda se actualiza

Escenario 8: Generar reportes

El usuario genera reportes de ventas o inventario.

●  Actor Principal: Propietaria
●  Precondiciones:

○  Existen datos registrados

●  Postcondiciones:

○  El usuario obtiene un reporte para su análisis

Flujo: Registrar venta

Flujo: Registrar venta

Ingresa cantidades

1.  El usuario inicia una nueva venta
2.  Selecciona productos o los escanea
3.
4.  Visualiza el total de la venta
5.  Selecciona el tipo de pago
6.  Conﬁrma la operación
7.  Visualiza un mensaje de conﬁrmación

Flujo: Registrar producto

1.  El usuario inicia el registro de producto
2.  Ingresa los datos o escanea el producto
3.  Revisa la información
4.  Conﬁrma el registro
5.  Visualiza conﬁrmación

Flujo: Actualizar producto

1.  El usuario accede al inventario
2.  Selecciona un producto
3.  Modiﬁca la información
4.  Conﬁrma los cambios
5.  Visualiza conﬁrmación

Flujo: Desactivar producto

1.  El usuario accede al inventario
2.  Selecciona un producto activo

3.  Elige la opción de desactivar
4.  Conﬁrma la acción
5.  Visualiza conﬁrmación

Flujo: Consultar inventario

1.  El usuario accede al inventario
2.  Visualiza la lista de productos
3.  Realiza búsquedas o aplica ﬁltros
4.  Revisa la información

Flujo: Gestión de deudas

1.  El usuario accede al módulo de deudas
2.  Visualiza la lista de clientes
3.  Selecciona un cliente
4.  Revisa el detalle de la deuda

Flujo: Registrar pago de deuda

1.  El usuario selecciona una deuda
2.  Ingresa el monto a pagar
3.  Conﬁrma el pago
4.  Visualiza conﬁrmación

Flujo: Generar reportes

1.  El usuario accede al módulo de reportes
2.  Selecciona el tipo de reporte
3.  Visualiza el reporte

4. Requisitos de Usuario

●  El usuario puede registrar ventas
●  El usuario puede realizar ventas al contado o crédito
●  El usuario puede gestionar productos (registrar, actualizar, desactivar y consultar)
●  El usuario puede gestionar deudas de clientes
●  El usuario puede consultar el inventario
●  El usuario puede generar reportes de ventas e inventario
●  El usuario puede registrar productos mediante escaneo
●  El usuario puede identiﬁcar productos con bajo stock o próximos a vencer
●  El usuario puede acceder a su información desde distintos momentos

●  El sistema debe ser fácil de usar e intuitivo
●  El sistema debe responder en menos de 3 segundos en operaciones comunes
●  El sistema debe garantizar la seguridad de la información
●  El sistema debe ser compatible con dispositivos móviles

5. Modelado de Interacción

HU: Registrar productos

YO

Como Usuario

QUIERO

Registrar productos en el inventario

PARA

Tener control de los productos disponibles

CRITERIOS DE ACEPTACIÓN

●  El usuario puede ingresar los datos generales del producto (nombre, categoría,

unidad de medida, precio y stock mínimo)

●  El usuario puede registrar productos manualmente o mediante escaneo de código

de barras

●  El sistema debe validar que los campos obligatorios estén completos antes de

guardar

●  El sistema no debe permitir registrar productos con datos inválidos (precio

negativo, cantidad negativa, etc.)

●  El sistema debe guardar el producto en el inventario correctamente
●  El sistema debe permitir visualizar el producto registrado en la lista de inventario sin

asociar información de lotes o vencimientos directamente al producto

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
●  Cuando se registra un pago parcial, el sistema debe mantener la deuda en estado

“pendiente” y actualizar automáticamente el monto restante adeudado

HU: Gestionar lotes

YO

Como Usuario

QUIERO

Registrar y gestionar lotes de productos

PARA

Controlar fechas de vencimiento, cantidades compradas y estado de los
productos almacenados

CRITERIOS DE ACEPTACIÓN

●  El usuario puede registrar un lote asociado a un producto existente
●  El usuario puede ingresar cantidad comprada, precio de compra, fecha de compra y

fecha de vencimiento

●  El sistema debe validar que el producto exista antes de registrar el lote
●  El sistema debe permitir editar información de lotes registrados
●  El sistema debe permitir eliminar lotes registrados
●  El sistema debe permitir visualizar el historial de lotes asociados a un producto
●  El sistema debe identiﬁcar lotes próximos a vencer
●  El sistema debe actualizar el stock disponible según los lotes registrados

HU: Gestionar clientes

YO

Como Usuario

QUIERO

Registrar y consultar clientes

PARA

Asociar ventas al crédito y mantener información organizada de mis
compradores

CRITERIOS DE ACEPTACIÓN

●  El usuario puede registrar clientes con información básica como nombre y DNI
●  El sistema debe validar datos obligatorios antes de guardar
●  El usuario puede consultar la lista de clientes registrados
●  El usuario puede buscar clientes por nombre
●  El sistema debe mostrar el estado de deuda de cada cliente
●  El usuario puede visualizar el historial de compras asociadas a un cliente
●  El sistema debe mantener actualizada la información de deuda del cliente

HU: Generar reporte detallado de ventas

YO

Como Usuario

QUIERO

Generar reportes detallados de ventas

PARA

Analizar las transacciones realizadas en un periodo especíﬁco

CRITERIOS DE ACEPTACIÓN

●  El usuario puede seleccionar un rango de fechas
●  El sistema debe mostrar ventas realizadas indicando cliente, productos, fecha y

monto total

●  El sistema debe permitir ﬁltrar ventas al contado y crédito
●  El sistema debe mostrar totales de ventas generadas
●  El usuario puede exportar el reporte en PDF

HU: Generar reporte de productos vendidos

YO

Como Usuario

QUIERO

Visualizar los productos más vendidos

PARA

Identiﬁcar los productos con mayor rotación

CRITERIOS DE ACEPTACIÓN

●  El sistema debe mostrar productos vendidos ordenados por cantidad
●  El usuario puede seleccionar un rango de fechas
●  El sistema debe mostrar cantidad total vendida por producto
●  El usuario puede exportar el reporte en PDF

HU: Generar reporte de inventario

YO

Como Usuario

QUIERO

Generar reportes del inventario actual

PARA

Conocer el estado de los productos almacenados

CRITERIOS DE ACEPTACIÓN

●  El sistema debe mostrar productos registrados con stock actual
●  El sistema debe indicar productos activos e inactivos
●  El sistema debe identiﬁcar productos con bajo stock
●  El usuario puede exportar el reporte en PDF

HU: Generar reporte de lotes

YO

Como Usuario

QUIERO

Generar reportes de lotes registrados

PARA

Controlar productos comprados y sus fechas de vencimiento

CRITERIOS DE ACEPTACIÓN

●  El sistema debe mostrar lotes registrados asociados a productos
●  El usuario puede ﬁltrar por rango de fechas
●  El sistema debe mostrar fecha de vencimiento y cantidad disponible
●  El usuario puede exportar el reporte en PDF

HU: Generar reporte de vencimientos

YO

Como Usuario

QUIERO

Consultar productos próximos a vencer

PARA

Conocer el estado de los productos almacenados

CRITERIOS DE ACEPTACIÓN

●  El sistema debe identiﬁcar productos próximos a vencer
●  El usuario puede deﬁnir cantidad de días previos al vencimiento
●  El sistema debe mostrar productos y lotes afectados
●  El usuario puede exportar el reporte en PDF

HU: Generar boleta de venta

YO

Como Usuario

QUIERO

Generar una boleta de venta

PARA

Entregar un comprobante con el detalle de la compra realizada

CRITERIOS DE ACEPTACIÓN

●  El sistema debe generar una boleta luego de registrar una venta
●  La boleta debe incluir productos, cantidades, precios y monto total
●  El sistema debe mostrar fecha y hora de la venta
●  El usuario puede descargar o compartir la boleta en formato PDF
●  El sistema debe mantener registro de las boletas generadas

HU: Gestionar notiﬁcaciones

YO

Como Usuario

QUIERO

Recibir notiﬁcaciones automáticas del sistema

PARA

Conocer eventos importantes relacionados con inventario y vencimientos

CRITERIOS DE ACEPTACIÓN

●  El sistema debe generar alertas por bajo stock
●  El sistema debe generar alertas por productos próximos a vencer
●  El usuario puede visualizar el historial de notiﬁcaciones
●  El usuario puede eliminar notiﬁcaciones registradas
●  El usuario puede conﬁgurar los días previos para alertas de vencimiento

HU: Gestionar reembolsos

YO

Como Usuario

QUIERO

Registrar reembolsos o devoluciones de productos

PARA

Mantener control correcto de ventas anuladas o productos devueltos

CRITERIOS DE ACEPTACIÓN

●  El usuario puede seleccionar una venta registrada previamente
●  El sistema debe permitir seleccionar productos a devolver
●  El usuario puede indicar motivo del reembolso
●  El sistema debe actualizar el inventario según los productos devueltos
●  El sistema debe actualizar la deuda del cliente si la venta fue al crédito
●  El sistema debe mantener historial de reembolsos realizados
