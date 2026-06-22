# Requerimientos y Casos de Uso

1. Introducción

Este documento tiene como propósito definir los requisitos funcionales y no funcionales del
sistema iVenti, una aplicación móvil orientada a la gestión de inventario y ventas para el
negocio Multiservicios Golden S.A. Se describe el comportamiento esperado del sistema, sus
principales funcionalidades, restricciones y características generales.

El sistema permite registrar y controlar productos, gestionar ventas al contado y a crédito,
administrar clientes deudores, generar reportes y emitir alertas relacionadas al estado del
inventario. Las operaciones del sistema requieren conexión a internet. No incluye módulos
para clientes o proveedores, ni pagos electrónicos.

● Sistema iVenti - Aplicación móvil para la gestión de inventario y ventas.
● Inventario - Conjunto de productos registrados con su stock disponible.
● Stock - Cantidad disponible de un producto en el inventario.
● Lote - Registro de ingreso de productos con atributos como cantidad, precio de
compra y fecha de vencimiento.
● Venta al contado - Transacción pagada en su totalidad en el momento de la compra.
● Venta a crédito - Transacción en la que el cliente adquiere una deuda pendiente.
● Cliente deudor - Cliente con saldo pendiente por ventas a crédito.
● Boleta - Documento generado que detalla una venta realizada.
● PIN - Código numérico de 6 dígitos utilizado para autenticación del usuario.
2. Descripción General

El sistema iVenti es una aplicación móvil orientada a la gestión de inventario y ventas, que
implementa los requisitos definidos a nivel de negocio y de usuario.
El sistema es operado por la propietaria del negocio, quien interactúa directamente con sus
funcionalidades para registrar productos, ventas, clientes y consultar información.
Asimismo, el sistema hace uso de capacidades del dispositivo móvil, como la cámara, para
funcionalidades específicas como el escaneo de códigos de barras.

● El sistema proporciona las siguientes funciones a nivel general:
● Gestionar productos y categorías del inventario
● Registrar y controlar lotes con fechas de vencimiento
● Procesar ventas al contado y a crédito
● Administrar clientes y sus deudas
● Generar boletas de venta y reportes
● Emitir notificaciones sobre eventos críticos del inventario
● Permitir búsqueda, filtrado y consulta de información
● Exportar información en formato PDF

El sistema contempla el siguiente tipo de usuario:
● Usuario principal (Propietaria del negocio)
Es el único usuario del sistema y responsable de ejecutar todas las funcionalidades,
incluyendo la gestión de inventario, ventas, clientes y generación de reportes.
No se contemplan múltiples roles ni niveles de acceso dentro del sistema.

● El usuario dispone de un dispositivo móvil compatible con el sistema.
● El usuario tiene acceso a un correo electrónico válido para el registro y verificación de
cuenta.
● El sistema requiere acceso a internet para el registro, almacenamiento y consulta de
la información.
● El sistema puede acceder a la cámara del dispositivo para el escaneo de códigos de
barras.
● El sistema depende de servicios externos de almacenamiento para el respaldo y
persistencia de datos.
● El almacenamiento local del dispositivo es utilizado como soporte para mejorar el
rendimiento de la aplicación.
3. Requisitos del Sistema

Código Nombre Descripción Depende Criterios de aceptación
RF-01 Registrar usuario El sistema debe Ninguna El usuario puede registrarse
permitir registrar una ingresando su correo electrónico y el
cuenta de usuario para sistema envía un código de
acceder al sistema verificación para validar la cuenta
RF-02 Verificar cuenta El sistema debe RF-01 El usuario puede ingresar el código
permitir verificar la recibido en su correo para activar su
cuenta mediante un cuenta
código enviado al
correo electrónico
RF-03 Establecer PIN de El sistema debe RF-02 El usuario puede crear un PIN de 6
acceso permitir configurar un dígitos que será utilizado para
PIN de acceso para acceder al sistema
iniciar sesión
RF-04 Iniciar sesión con El sistema debe RF-03 El usuario puede acceder al sistema
el PIN de usuario permitir el acceso ingresando correctamente su PIN de
mediante el PIN de 6 dígitos
usuario
RF-05 Solicitar PIN al El sistema debe RF-04 El sistema muestra la pantalla de
acceder solicitar nuevamente el ingreso del PIN de usuario al volver a
nuevamente PIN cuando la acceder.
aplicación se cierre
completamente

Código Nombre Descripción Depende Criterios de aceptación
RF-06 Registrar El sistema debe permitir Ninguna El usuario puede registrar
producto registrar nuevos productos productos indicando nombre,
en el inventario unidad de medida, precio, stock
mínimo y categorías. El sistema
valida los campos obligatorios
antes de guardar el producto
RF-07 Escanear El sistema debe permitir Ninguna El usuario puede escanear códigos
código de escanear códigos de barras de barras utilizando la cámara del
barras para identificar productos dispositivo y el sistema reconoce
el producto asociado
RF-08 Registrar El sistema debe permitir Ninguna El usuario puede seleccionar
imagen de asociar imágenes a los imágenes desde la galería o tomar

producto productos registrados fotografías con la cámara del
dispositivo
RF-09 Gestionar El sistema debe permitir Ninguna El usuario puede crear nuevas
categorías registrar, editar y eliminar categorías, modificar nombres
categorías de productos existentes y eliminar categorías
registradas
RF-10 Listar El sistema debe permitir RF-06 El sistema muestra la lista de
productos visualizar los productos productos indicando nombre,
registrados en el inventario precio y stock
RF-11 Buscar y filtrar El sistema debe permitir RF-10 El usuario puede buscar productos
productos buscar productos y aplicar por nombre y filtrar los resultados
filtros dentro del inventario por categorías y nivel de stock
(bajo o normal)
RF-12 Actualizar El sistema debe permitir RF-10 El usuario puede actualizar
producto modificar la información de información del producto y guardar
productos registrados los cambios realizados
RF-13 Desactivar y El sistema debe permitir RF-6 El usuario puede cambiar el estado
reactivar desactivar productos sin del producto a inactivo o activo.
producto eliminar su información y Los productos inactivos no pueden
reactivarlos posteriormente utilizarse en nuevas ventas
RF-14 Gestionar lotes El sistema debe permitir RF-6 El usuario puede registrar lotes
registrar, editar y eliminar indicando cantidad comprada,
lotes de productos cantidad perdida, precio de
compra, fecha de compra y fecha
de vencimiento. También puede
modificar o eliminar lotes
registrados
RF-15 Visualizar El sistema debe permitir RF-10 El usuario puede visualizar
detalle de visualizar la información información detallada del producto
producto detallada de un producto como categorías, stock, lotes y
registrado fecha de vencimiento
RF-16 Visualizar El sistema debe permitir RF-14 El sistema muestra información del
detalle de lote visualizar la información lote como cantidad comprada,
detallada de un lote cantidad perdida, precio de
registrado compra y fecha de vencimiento

Código Nombre Descripción Depende Criterios de aceptación
RF-17 Gestionar El sistema debe permitir RF-10 El usuario puede buscar o
productos en agregar, editar y eliminar escanear productos para

ventas productos dentro de una agregarlos a una venta, modificar
venta cantidades o eliminar productos
antes de confirmar la venta
RF-18 Registrar venta El sistema debe permitir RF-17 El usuario puede ingresar el monto
al contado registrar ventas con pago al recibido y se calcula
contado automáticamente el vuelto antes
de registrar la venta
RF-19 Registrar venta El sistema debe permitir RF-17, El usuario puede registrar una
a crédito registrar ventas a crédito RF-25 venta a crédito con o sin adelanto
de pago y se calcula
automáticamente la deuda
asociada al cliente. El sistema
exige seleccionar o registrar un
cliente antes de confirmar este tipo
de venta.
RF-20 Generar boleta El sistema debe permitir RF-18, El sistema genera una boleta con
de venta generar boletas de las RF-19 el detalle de la venta registrada
ventas registradas
RF-21 Exportar boleta El sistema debe permitir RF-20 El usuario puede descargar,
de venta en exportar boletas de venta compartir o imprimir la boleta de
PDF en formato PDF venta generada en formato PDF.
RF-22 Listar ventas El sistema debe permitir RF-18, El sistema muestra la lista de
visualizar las ventas RF-19 ventas indicando cliente, fecha,
registradas monto y tipo de pago
RF-23 Buscar y filtrar El sistema debe permitir RF-22 El usuario puede buscar ventas por
ventas buscar y filtrar ventas código y aplicar filtros por tipo de
registradas pago (al contado o crédito) y rango
de fechas
RF-24 Visualizar El sistema debe permitir RF-22 El sistema muestra el código de
detalle de visualizar la información venta, cliente, DNI, fecha, hora,
venta detallada de una venta monto total, monto cancelado, tipo
registrada de pago y el listado de productos
vendidos indicando cantidad,
unidad de medida, descripción,
precio y subtotal. El usuario puede
descargar, compartir o imprimir el
detalle de la venta

Código Nombre Descripción Depende Criterios de aceptación
RF-25 Registrar cliente El sistema debe Ninguna El usuario puede registrar clientes

permitir registrar ingresando su información antes de
clientes asociados a confirmar una venta
las ventas
RF-26 Listar clientes El sistema debe RF-25 El sistema muestra la lista de clientes
permitir visualizar los indicando nombre, última compra,
clientes registrados monto adeudado y estado
RF-27 Buscar y filtrar El sistema debe RF-25 El usuario puede buscar clientes por
clientes permitir buscar y filtrar nombre y filtrar los resultados por
clientes registrados estado de deuda (deudor o regular)
RF-28 Visualizar detalle El sistema debe RF-26 El sistema muestra información del
de cliente permitir visualizar la cliente como nombre, DNI, correo
información detallada electrónico, monto total de compras
de un cliente y el historial de ventas asociadas,
registrado permitiendo acceder al detalle de
cada venta
RF-29 Registrar pago de El sistema debe RF-19, El usuario puede ingresar un monto
deuda permitir registrar pagos RF-28 de pago y el sistema actualiza
parciales o totales de automáticamente el saldo pendiente
deudas y el estado de la deuda del cliente

Código Nombre Descripción Depende Criterios de aceptación
RF-30 Generar reporte El sistema debe RF-22, El sistema genera un reporte
detallado de permitir generar un RF-23 detallado de ventas en un rango de
ventas reporte detallado de fechas, permitiendo seleccionar el
ventas en un rango de tipo de venta (general, al contado o
fechas al crédito), mostrando información de
productos vendidos, cliente, fecha,
hora y monto total
RF-31 Generar reporte El sistema debe RF-22 El sistema genera un reporte de
de productos permitir generar un productos vendidos ordenados de
vendidos reporte de productos mayor a menor cantidad en un rango
vendidos de fechas seleccionado
RF-32 Generar reporte El sistema debe RF-10 El sistema genera un reporte del
de inventario permitir generar un inventario actual o histórico según la
reporte del inventario fecha seleccionada, mostrando los
productos registrados
RF-33 Generar reporte El sistema debe RF-14 El sistema genera un reporte de
de lotes permitir generar un lotes en el que el usuario puede
reporte de lotes de seleccionar el tipo de lote (general o
productos actuales), un rango de fechas y los

días restantes para productos
próximos a vencer
RF-34 Generar reporte El sistema debe RF-14 El sistema genera un reporte de
de vencimientos permitir generar un productos próximos a vencer según
reporte de productos los días ingresados por el usuario
próximos a vencer
RF-35 Exportar reportes El sistema debe RF-30, El usuario puede descargar,
en PDF permitir exportar los RF-31, compartir o imprimir cualquier
reportes generados en RF-32, reporte generado en formato PDF.
formato PDF RF-33,
RF-34

Código Nombre Descripción Depende Criterios de aceptación
RF-36 Generar El sistema debe RF-10, El sistema genera notificaciones
notificaciones generar notificaciones RF-15 cuando un producto presenta stock
automáticas por bajo o cuando un lote está próximo a
eventos del inventario vencer.
RF-37 Visualizar El sistema debe RF-36 El usuario puede visualizar el historial
notificaciones permitir visualizar el de notificaciones generadas por el
historial de sistema.
notificaciones
RF-38 Eliminar El sistema debe RF-37 El usuario puede eliminar
notificaciones permitir eliminar notificaciones registradas del
notificaciones historial de forma individual o total.
registradas
RF-39 Configurar días El sistema debe RF-36 El usuario puede definir los días
de notificación permitir configurar los previos a la fecha de vencimiento
días previos para para generar notificaciones, siendo 8
generar alertas de días el valor predeterminado
vencimiento de
productos

Código  Nombre  Descripción  Prioridad  Criterios de aceptación
RNF-01  Interfaz intuitiva  El sistema debe contar  Alta  El usuario puede realizar las

| --- | ------------------------- | ---------------------------------- |

conocimientos básicos
de tecnología
RNF-02  Diseño  El sistema debe  Alta  La interfaz presenta una estructura
simplificado  presentar únicamente  clara y organizada, permitiendo que

| --- | -------------------------- | -------------------------------------- |

confusión al usuario
RNF-03  Adaptabilidad a  El sistema debe  Media  El sistema puede ejecutarse
| tablets  | funcionar               | correctamente y mantener una  |
| -------- | ----------------------- | ----------------------------- |

Galaxy Tab S6 Lite
RNF-04  Material de apoyo  El sistema debe incluir  Baja  El usuario puede acceder a videos

| --- | ------------------ | ---------------------------------- |

aprendizaje y uso de la
aplicación

Código  Nombre  Descripción  Prioridad  Criterios de aceptación
RNF-05  Tiempo de  El sistema debe  Alta  Las funcionalidades principales
respuesta  responder de manera  responden en pocos segundos bajo

| --- | ---------------------- | ---------------------------- |
de sus funcionalidades
RNF-06  Estabilidad del  El sistema debe  Alta  El sistema no presenta cierres
| sistema  | mantener un     | inesperados ni interrupciones     |
| -------- | --------------- | --------------------------------- |

estable durante su uso
continuo

Código  Nombre  Descripción  Prioridad  Criterios de aceptación
RNF-07  Acceso seguro al  El sistema debe  Alta  El usuario debe autenticarse
sistema  permitir el acceso  correctamente antes de acceder a

| --- | ---------------------- | -------------------------------- |
autorizados
RNF-08  Protección de  El sistema debe  Alta  La información registrada y
información  proteger la información  consultada no puede ser visualizada

| --- | --------------------- | ------------------------------ |

aplicación y la base de
datos remota
RNF-09  Validación de  El sistema debe validar  Media  El sistema impide registrar
información  la información  información incompleta o inválida
ingresada antes de
almacenarla
RNF-10  Integridad de  El sistema debe  Media  La información registrada mantiene
| datos  | mantener la   | coherencia y relaciones adecuadas  |
| ------ | ------------- | ---------------------------------- |

consistencia de la
información
almacenada

Código  Nombre  Descripción  Prioridad  Criterios de aceptación
RNF-11  Operatividad del  El sistema debe  Alta  El usuario puede acceder y utilizar
sistema  mantenerse disponible  las funcionalidades principales del

| --- | ---------------------- | ----------------------------------- |

RNF-12  Conectividad del  El sistema debe  Alta  El sistema puede acceder a la
| sistema  | mantener una          | información correctamente mientras  |
| -------- | --------------------- | ----------------------------------- |

la base de datos
remota durante su
funcionamiento

4. Modelado del Sistema

A continuación, se presenta el diagrama de actores del sistema iVenti:
Descripción de los actores:
1. Usuario (Propietaria)
Interactúa con el sistema para gestionar productos, ventas, deudas y reportes.
2. Servicio en la nube
Servicio externo que almacena y respalda la información del sistema.
3. Dispositivo de escaneo
Dispositivo externo que envía la información de los productos al sistema.

CU-01 Registrar usuario
Descripción Permite al usuario crear una cuenta en el sistema mediante su correo
electrónico.
Actor Usuario
Precondiciones ● El usuario no debe tener una cuenta registrada
● El usuario tiene acceso a un correo electrónico válido
Postcondiciones ● La cuenta queda registrada en el sistema en estado pendiente de
verificación
Flujo principal 1. El usuario selecciona la opción “Registrarse”.
2. El sistema muestra el formulario de registro.
3. El usuario ingresa su correo electrónico.
4. El sistema valida el formato del correo.
5. El sistema envía un código de verificación al correo.
6. El sistema registra la cuenta en estado pendiente.
Flujos alternos A1: Correo inválido
● 4a. El sistema detecta formato incorrecto
● 4b. Muestra mensaje de error
● 4c. Retorna al paso 3
A2: Correo ya registrado
● 4a. El sistema detecta duplicidad
● 4b. Muestra mensaje
● 4c. Finaliza el caso de uso
CU-02 Activar cuenta
Descripción Permite al usuario verificar su cuenta mediante código y configurar su
PIN de acceso.
Actor Usuario
Precondiciones ● El usuario tiene una cuenta registrada
● Ha recibido el código de verificación
Postcondiciones ● La cuenta queda activada

● El PIN queda registrado
Flujo principal 1. El usuario ingresa el código recibido.
2. El sistema valida el código.
3. El sistema solicita la creación de un PIN.
4. El usuario ingresa un PIN de 6 dígitos.
5. El sistema valida el formato del PIN.
6. El sistema activa la cuenta.
7. El sistema guarda el PIN.
Flujos alternos A1: Código incorrecto
● 2a. El sistema detecta error
● 2b. Muestra mensaje
● 2c. Permite reintento
A2: PIN inválido
● 5a. El sistema detecta formato incorrecto
● 5b. Muestra mensaje
● 5c. Retorna al paso 4
CU-03 Iniciar sesión
Descripción Permite al usuario acceder al sistema mediante su PIN.
Actor Usuario
Precondiciones ● El usuario tiene una cuenta activa
● El PIN está configurado
Postcondiciones ● El usuario accede al sistema
Flujo principal 1. El sistema muestra la pantalla de ingreso.
2. El usuario ingresa su PIN.
3. El sistema valida el PIN.
4. El sistema permite el acceso.
Flujos alternos A1: PIN incorrecto
● 3a. El sistema muestra error
● 3b. Permite reintento
CU-04 Registrar producto

Descripción Permite al usuario registrar un nuevo producto en el inventario.
Actor Usuario
Precondiciones ● El usuario ha iniciado sesión
Postcondiciones ● El producto queda registrado en el sistema
Flujo principal 1. El usuario accede a la opción “Registrar producto”.
2. El sistema muestra el formulario.
3. El usuario ingresa los datos (nombre, precio, unidad, categoría,
stock mínimo).
4. (Opcional) El usuario escanea el código de barras.
5. (Opcional) El usuario agrega imagen.
6. El sistema valida los datos.
7. El usuario confirma el registro.
8. El sistema guarda el producto.
Flujos alternos A1: Datos incompletos
● 6a. El sistema detecta error
● 6b. Muestra mensaje
● 6c. Retorna al paso 3
A2: Producto duplicado
● 6a. El sistema detecta duplicidad
● 6b. Muestra mensaje
● 6c. Cancela registro
CU-05 Gestionar categorías
Descripción Permite al usuario crear, editar o eliminar categorías de productos.
Actor Usuario
Precondiciones ● El usuario ha iniciado sesión
Postcondiciones ● Las categorías quedan actualizadas en el sistema
Flujo principal 1. El usuario accede al módulo de categorías.
2. El sistema muestra la lista de categorías.
3. El usuario selecciona crear, editar o eliminar.
4. El usuario ingresa o modifica el nombre.
5. El sistema valida la información.

6. El sistema guarda los cambios.
Flujos alternos A1: Nombre inválido
● 5a. El sistema muestra error
● 5b. Retorna al paso 4
A2: Eliminación con productos asociados
● 5a. El sistema detecta relación
● 5b. Muestra advertencia
● 5c. Cancela eliminación
CU-06 Consultar inventario
Descripción Permite al usuario buscar y filtrar los productos registrados en el
inventario.
Actor Usuario
Precondiciones ● El usuario ha iniciado sesión
● Existen productos registrados
Postcondiciones ● El usuario visualiza la lista actualizada de productos
Flujo principal 1. El usuario accede a “Inventario”.
2. El sistema muestra la lista de productos.
3. El usuario puede buscar por nombre.
4. El usuario puede aplicar filtros (categoría, stock, estado).
5. El sistema actualiza la lista según los filtros.
Flujos alternos A1: No hay productos registrados
● 2a. El sistema muestra mensaje “inventario vacío”
● 2b. Finaliza el caso de uso
CU-07 Actualizar producto
Descripción Permite al usuario modificar la información de un producto registrado.
Actor Usuario
Precondiciones ● El producto existe en el inventario

Postcondiciones ● La información del producto queda actualizada
Flujo principal 1. El usuario selecciona un producto.
2. El sistema muestra los datos actuales.
3. El usuario modifica la información.
4. El sistema valida los datos.
5. El usuario confirma cambios.
6. El sistema actualiza el producto.
Flujos alternos A1: Datos inválidos
● 4a. El sistema muestra error
● 4b. Retorna a edición
CU-08 Cambiar estado de producto
Descripción Permite activar o desactivar productos sin eliminar su información.
Actor Usuario
Precondiciones ● El producto existe
Postcondiciones ● El estado del producto queda actualizado
Flujo principal 1. El usuario selecciona un producto.
2. El sistema muestra opciones.
3. El usuario elige activar o desactivar.
4. El sistema actualiza el estado.
5. El sistema confirma la operación.
Flujos alternos A1: Producto con ventas asociadas
● 3a. El sistema permite desactivar pero no eliminar
● 3b. Muestra advertencia informativa
CU-09 Gestionar lotes de productos
Descripción Permite registrar y administrar lotes asociados a productos.
Actor Usuario

Precondiciones ● El producto existe
Postcondiciones ● El lote queda registrado o actualizado
Flujo principal 1. El usuario accede a un producto.
2. Selecciona “Gestionar lotes”.
3. El sistema muestra los lotes existentes.
4. El usuario agrega o edita un lote.
5. Ingresa cantidad, costo y vencimiento.
6. El sistema valida datos.
7. El sistema guarda el lote.
Flujos alternos A1: Fecha inválida o vencida
● 6a. El sistema muestra error
● 6b. Retorna a edición
CU-10 Ver detalle de producto
Descripción Permite visualizar la información completa de un producto.
Actor Usuario
Precondiciones ● El producto existe
Postcondiciones ● Se muestra el detalle del producto
Flujo principal 1. El usuario selecciona un producto.
2. El sistema muestra información general.
3. El sistema muestra stock, lotes y categoría.
4. El usuario revisa la información.
Flujos alternos A1: Producto no encontrado
● 1a. El sistema muestra mensaje de error
● 1b. Finaliza el caso
CU-11 Gestionar venta
Descripción Permite al usuario agregar, modificar o eliminar productos dentro de una
venta en curso.

Actor Usuario
Precondiciones ● El usuario ha iniciado sesión
● Existen productos en el inventario
Postcondiciones ● Se genera una lista temporal de productos para la venta
Flujo principal 1. El usuario inicia una nueva venta.
2. El sistema muestra el catálogo de productos.
3. El usuario busca o escanea productos.
4. El sistema agrega productos a la venta.
5. El usuario modifica cantidades o elimina productos.
6. El sistema actualiza el total en tiempo real.
Flujos alternos A1: Producto sin stock
● 4a. El sistema alerta stock insuficiente
● 4b. No agrega el producto
CU-12 Registrar venta
Descripción Permite registrar una venta al contado o a crédito.
Actor Usuario
Precondiciones ● Existe una venta en proceso
Postcondiciones ● La venta queda registrada en el sistema
● El inventario se actualiza
Flujo principal 1. El usuario finaliza la selección de productos.
2. El sistema muestra el resumen de la venta.
3. El usuario selecciona tipo de pago (contado o crédito).
4. Si es contado, ingresa el monto recibido.
5. El sistema calcula el total y vuelto (si aplica).
6. Si es crédito, el sistema registra deuda asociada.
7. El usuario confirma la venta.
8. El sistema guarda la venta.
9. El sistema actualiza el inventario.
Flujos alternos A1: Monto insuficiente
● 5a. El sistema muestra error
● 5b. Solicita corrección

A2: Cliente no registrado
● 6a. El sistema solicita registrar cliente
● 6b. Retorna al paso 3
CU-13 Generar boleta de venta
Descripción Permite generar el comprobante digital de una venta registrada.
Actor Usuario
Precondiciones ● La venta ha sido registrada
Postcondiciones ● Se genera la boleta de venta
Flujo principal 1. El sistema finaliza la venta.
2. El sistema asigna número de boleta.
3. El sistema genera el comprobante digital.
4. El usuario puede visualizar la boleta.
Flujos alternos A1: Error de generación
● 3a. El sistema muestra mensaje de error
● 3b. Reintenta generación
CU-14 Consultar ventas
Descripción Permite visualizar el historial de ventas realizadas.
Actor Usuario
Precondiciones ● Existen ventas registradas
Postcondiciones ● El usuario visualiza el historial de ventas

Flujo principal 1. El usuario accede a “Ventas”.
2. El sistema muestra lista de ventas.
3. El usuario puede buscar por código o cliente.
4. El usuario puede filtrar por fecha o tipo de pago.
Flujos alternos A1: No hay ventas registradas
● 2a. El sistema muestra mensaje vacío
● 2b. Finaliza
CU-15 Ver detalle de venta
Descripción Permite visualizar la información completa de una venta registrada.
Actor Usuario
Precondiciones ● La venta existe
Postcondiciones ● Se muestra el detalle completo de la venta
Flujo principal 1. El usuario selecciona una venta.
2. El sistema muestra datos generales.
3. El sistema muestra productos, cantidades y precios.
4. El sistema muestra cliente y tipo de pago.
5. El usuario revisa la información.
Flujos alternos A1: Venta no encontrada
● 1a. El sistema muestra error
● 1b. Finaliza
CU-16 Registrar cliente
Descripción Permite registrar un nuevo cliente en el sistema para asociarlo a ventas o
deudas.
Actor Usuario
Precondiciones ● El usuario ha iniciado sesión

Postcondiciones ● El cliente queda registrado en el sistema
Flujo principal 1. El usuario accede a “Clientes”.
2. Selecciona “Registrar cliente”.
3. El sistema muestra formulario.
4. El usuario ingresa datos (nombre, DNI, contacto).
5. El sistema valida la información.
6. El sistema guarda el cliente.
Flujos alternos A1: Datos inválidos
● 5a. El sistema muestra error
● 5b. Retorna a edición
CU-17 Consultar clientes
Descripción Permite visualizar, buscar y filtrar clientes registrados.
Actor Usuario
Precondiciones ● Existen clientes registrados
Postcondiciones ● Se muestra lista actualizada de clientes
Flujo principal 1. El usuario accede al módulo de clientes.
2. El sistema muestra lista de clientes.
3. El usuario busca por nombre o DNI.
4. El usuario filtra por estado (deudor o regular).
5. El sistema actualiza resultados.
Flujos alternos A1: Sin clientes registrados
● 2a. El sistema muestra mensaje vacío
● 2b. Finaliza
CU-18 Ver detalle de cliente
Descripción Permite visualizar información completa de un cliente y su historial de
compras.
Actor Usuario
Precondiciones ● El cliente existe

Postcondiciones ● Se muestra información detallada del cliente
Flujo principal 1. El usuario selecciona un cliente.
2. El sistema muestra datos personales.
3. El sistema muestra historial de ventas.
4. El sistema muestra saldo de deuda actual.
5. El usuario revisa información.
Flujos alternos A1: Cliente no encontrado
● 1a. El sistema muestra error
● 1b. Finaliza
CU-19 Registrar pago de deuda
Descripción Permite registrar pagos parciales o totales de una deuda de cliente.
Actor Usuario
Precondiciones ● El cliente tiene deuda registrada
Postcondiciones ● La deuda queda actualizada
Flujo principal 1. El usuario selecciona cliente con deuda.
2. El sistema muestra detalle de deuda.
3. El usuario ingresa monto de pago.
4. El sistema valida el monto.
5. El sistema actualiza saldo.
6. El sistema registra el pago.
Flujos alternos A1: Monto mayor a deuda
● 4a. El sistema muestra advertencia
● 4b. Solicita corrección
CU-20 Consultar deudas
Descripción Permite visualizar clientes con saldo pendiente.
Actor Usuario
Precondiciones ● Existen ventas a crédito registradas

Postcondiciones ● Se muestra lista de clientes deudores
Flujo principal 1. El usuario accede a “Deudas”.
2. El sistema filtra clientes con saldo > 0.
3. El sistema muestra lista de deudores.
4. El usuario selecciona un cliente para ver detalle.
Flujos alternos A1: No hay deudores
● 2a. El sistema muestra mensaje
● 2b. Finaliza
CU-21 Generar reportes
Descripción Permite al usuario generar reportes del sistema (ventas, inventario,
productos, lotes o vencimientos) según el tipo seleccionado.
Actor Usuario
Precondiciones ● El usuario ha iniciado sesión
● Existen datos en el sistema
Postcondiciones ● El reporte es generado y mostrado en pantalla
Flujo principal 1. El usuario accede al módulo de reportes.
2. El sistema muestra tipos de reporte disponibles.
3. El usuario selecciona tipo de reporte.
4. El usuario define filtros (fecha, categoría, tipo de venta, etc.).
5. El sistema procesa la información.
6. El sistema genera el reporte.
7. El sistema muestra el resultado en pantalla.
Flujos alternos A1: Sin datos disponibles
● 5a. El sistema detecta ausencia de datos
● 5b. Muestra mensaje
● 5c. Cancela generación
CU-22 Exportar reporte
Descripción Permite exportar un reporte generado en formato PDF.
Actor Usuario

Precondiciones ● Existe un reporte generado
Postcondiciones ● El archivo PDF queda disponible para descarga o envío
Flujo principal 1. El usuario visualiza el reporte.
2. Selecciona opción “Exportar PDF”.
3. El sistema genera el archivo.
4. El sistema permite descargar o compartir.
Flujos alternos A1: Error de generación
● 3a. El sistema muestra error
● 3b. Cancela exportación
CU-23 Gestionar notificaciones del sistema
Descripción Permite visualizar y gestionar las notificaciones generadas por el sistema.
Actor Usuario
Precondiciones ● El sistema ha generado notificaciones
Postcondiciones ● El usuario gestiona el historial de notificaciones
Flujo principal 1. El usuario accede a “Notificaciones”.
2. El sistema muestra el historial.
3. El usuario revisa alertas (stock bajo, vencimientos).
4. El usuario puede eliminar notificaciones.
Flujos alternos A1: Sin notificaciones
● 2a. El sistema muestra mensaje vacío
● 2b. Finaliza
CU-24 Configurar alertas de inventario
Descripción Permite configurar parámetros para generación de alertas automáticas del
sistema.
Actor Usuario

Precondiciones ● El usuario ha iniciado sesión
Postcondiciones ● Las reglas de notificación quedan configuradas
Flujo principal 1. El usuario accede a configuración de alertas.
2. El sistema muestra opciones (stock mínimo, días de vencimiento).
3. El usuario modifica valores.
4. El sistema guarda configuración.
5. El sistema aplica reglas automáticamente.
Flujos alternos A1: Valor inválido
● 3a. El sistema muestra error
● 3b. Retorna a edición
CU-25 Visualizar alertas automáticas
Descripción Permite al usuario visualizar alertas generadas automáticamente por el
sistema.
Actor Usuario
Precondiciones ● Existen eventos del sistema (stock bajo, vencimientos)
Postcondiciones ● El usuario visualiza alertas activas
Flujo principal 1. El usuario accede a “Alertas”.
2. El sistema muestra notificaciones automáticas.
3. El usuario revisa el estado de productos afectados.
Flujos alternos A1: Sin alertas activas
● 2a. El sistema muestra mensaje
● 2b. Finaliza

A continuación se presenta la matriz de trazabilidad de los requisitos funcionales con los
casos de uso del sistema iVenti.
Leyenda:

● RF = Requisitos Funcionales
● CU = Casos de Uso
● Relación: un RF puede aparecer en varios CU y viceversa
1. Acceso al sistema
RF Descripción CU relacionados
RF-01 Registrar usuario CU-01
RF-02 Verificar cuenta CU-02
RF-03 Establecer PIN de acceso CU-02
RF-04 Iniciar sesión con PIN CU-03
RF-05 Solicitar PIN al reingreso CU-03
2. Gestión de inventario
RF Descripción CU relacionados
RF-06 Registrar producto CU-04
RF-07 Escanear código de barras CU-04
RF-08 Registrar imagen de producto CU-04
RF-09 Gestionar categorías CU-05
RF-10 Listar productos CU-06, CU-07, CU-08, CU-10
RF-11 Buscar y filtrar productos CU-06
RF-12 Actualizar producto CU-07
RF-13 Desactivar/reactivar producto CU-08
RF-14 Gestionar lotes CU-09
RF-15 Visualizar detalle de lote CU-09, CU-10
RF-16 Visualizar detalle de producto CU-10
3. Gestión de ventas
RF Descripción CU relacionados

RF-17 Gestionar productos en CU-11
venta
RF-18 Venta al contado CU-12
RF-19 Venta a crédito CU-12
RF-20 Generar boleta de venta CU-13
RF-21 Exportar boleta PDF CU-13
RF-22 Listar ventas CU-14, CU-15
RF-23 Buscar/filtrar ventas CU-14
RF-24 Detalle de venta CU-15
4. Gestión de clientes
RF Descripción CU relacionados
RF-25 Registrar cliente CU-16, CU-12
RF-26 Listar clientes CU-17
RF-27 Buscar/filtrar clientes CU-17
RF-28 Detalle de cliente CU-18
RF-29 Registrar pago de CU-19
deuda
5. Reportes
RF Descripción CU relacionados
RF-30 Reporte ventas detallado CU-21
RF-31 Reporte productos CU-21
vendidos
RF-32 Reporte inventario CU-21
RF-33 Reporte lotes CU-21
RF-34 Reporte vencimientos CU-21
RF-35 Exportar reportes PDF CU-22
6. Notificaciones

RF Descripción CU relacionados
RF-36 Generar notificaciones automáticas CU-25
RF-37 Ver notificaciones CU-23
RF-38 Eliminar notificaciones CU-23
RF-39 Configurar alertas de vencimiento CU-24
5. Restricciones del Sistema

● El sistema se desarrolla utilizando Flutter como framework principal.
● Se utilizará una base de datos en la nube Postgresql
● El sistema depende del acceso a la cámara para funcionalidades de escaneo.

● La generación de boletas es de uso interno y no tiene validez tributaria.
