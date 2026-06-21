# Diagrama de Paquetes y Arquitectura


1. Introducción

El presente documento tiene como propósito describir la arquitectura de software del sistema

iVenti, detallando su organización lógica, estructura de datos, mecanismos de despliegue y

decisiones de diseño. Este documento permite comprender cómo está construido el sistema

a nivel técnico, facilitando su análisis, mantenimiento y futura evolución.

El documento abarca la arquitectura del sistema iVenti desde una perspectiva de software,

incluyendo la vista lógica, la vista de datos, la vista de despliegue y las integraciones con

servicios externos. Asimismo, se describe la infraestructura utilizada en el entorno cloud y las

restricciones técnicas del sistema.

●

iVenti: Sistema móvil de gestión de inventario y ventas.

●  API: Interfaz de programación de aplicaciones que permite la comunicación entre el

cliente y el servidor.

●  Flutter: Framework de desarrollo de aplicaciones móviles multiplataforma.
●  PostgreSQL: Sistema de gestión de bases de datos relacional utilizado para el

almacenamiento de datos.

2. Visión General de la Arquitectura

El sistema iVenti está basado en una arquitectura híbrida orientada a cliente con persistencia

distribuida, implementada principalmente mediante Flutter.

A nivel estructural, el sistema adopta un enfoque modular basado en funcionalidades, donde

cada módulo del sistema (inventario, ventas, clientes, reportes, etc.) se organiza de forma

independiente para mejorar la mantenibilidad y escalabilidad.

El sistema se apoya en los siguientes componentes arquitectónicos:

●  Capa de presentación (Cliente móvil): desarrollada en Flutter, encargada de la

interacción con el usuario y la visualización de datos.

●  Capa de datos remota: basada en una base de datos PostgreSQL, utilizada como

repositorio central de información.

La arquitectura del sistema iVenti tiene como objetivos principales:

●  Modularidad del sistema: organizar el código en módulos funcionales

independientes para facilitar su mantenimiento y evolución.

●  Centralización de datos: garantizar que la información principal del sistema se

almacene en una base de datos PostgreSQL.

●  Disponibilidad de datos: permitir el uso de almacenamiento local como soporte en

caso de fallos de conectividad.

3. Arquitectura de Software

A continuación, se presenta el diagrama de paquetes del sistema iVenti, el cual muestra la

organización modular de la aplicación:

Módulo de Autenticación (Auth)

Este módulo es responsable de la gestión del acceso al sistema iVenti. Permite el registro de

usuarios mediante correo electrónico, la veriﬁcación de cuentas mediante códigos de

conﬁrmación y la autenticación mediante un PIN de acceso.

Además, garantiza que únicamente usuarios autorizados puedan acceder a las

funcionalidades del sistema, actuando como un punto de control transversal para todos los

módulos de la aplicación.

Módulo de Inventario (Inventory)

El módulo de Inventario gestiona el registro, actualización y consulta de productos

disponibles en el negocio. Permite la administración de categorías, control de stock, registro

de imágenes, escaneo de códigos de barras y gestión de lotes con fechas de vencimiento.

Módulo de Ventas (Sales)

Este módulo permite la gestión de transacciones comerciales del negocio. Incluye la creación

de ventas al contado y a crédito, el cálculo automático de totales y vueltos, y la generación

de boletas digitales.

Además, mantiene la relación entre ventas, productos y clientes, permitiendo el seguimiento

detallado de cada transacción realizada.

Módulo de Clientes (Customers)

El módulo de Clientes administra la información de los compradores del negocio. Permite el

registro de clientes, la consulta de su historial de compras y la gestión de deudas asociadas a

ventas a crédito.

Módulo de Reportes (Reports)

Este módulo se encarga de la generación de reportes analíticos del sistema. Permite obtener

información detallada sobre ventas, inventario, productos más vendidos, lotes registrados y

productos próximos a vencer.

Módulo de Ajustes (Settings)

El módulo de Ajustes genera alertas automáticas basadas en eventos del sistema, como

niveles bajos de stock o proximidad de vencimiento de productos o notiﬁcaciones.

Además, permite la conﬁguración de parámetros de alerta y la visualización del historial de

notiﬁcaciones generadas, facilitando el control preventivo del inventario.

4. Arquitectura de Datos

A continuación, se presenta el Modelo Lógico de Datos del sistema iVenti, el cual representa la estructura lógica de la base de datos, incluyendo

las entidades principales, sus atributos y las relaciones entre ellas.

Seguidamente, se presenta el modelo físico de la base de datos del sistema iVenti, el cual detalla la implementación de las entidades en tablas,

incluyendo tipos de datos, claves primarias y relaciones en PostgreSQL.

5. Arquitectura de Sistema e Infraestructura

A continuación, se presenta el diagrama de despliegue del sistema iVenti, el cual representa

la distribución física de los componentes del sistema en el entorno de ejecución:

A continuación, se presenta el diagrama de arquitectura del sistema iVenti, el cual muestra la

interacción entre la aplicación móvil, los servicios externos y la base de datos.

El sistema iVenti se encuentra desplegado en un entorno cloud que permite su

funcionamiento continuo y accesible desde dispositivos móviles con conexión a internet.

Base de datos Neon PostgreSQL

El sistema utiliza una base de datos PostgreSQL alojada en la nube, la cual actúa como

repositorio central de toda la información del sistema.

En esta base de datos se almacenan datos relacionados con productos, ventas, clientes,

lotes, usuarios y reportes, garantizando la persistencia y consistencia de la información.

6. Integraciones Externas

El sistema iVenti integra servicios externos mediante APIs REST para ampliar sus

funcionalidades principales. Estas integraciones permiten la comunicación con servicios fuera

del sistema central, facilitando procesos complementarios.

Entre las principales APIs utilizadas se encuentran servicios para el envío de correos

electrónicos, utilizados en el proceso de registro y veriﬁcación de usuarios, así como en la

recuperación o validación de información del sistema.

El sistema también utiliza servicios externos para funciones especíﬁcas que no forman parte

del núcleo del sistema:

●  Cámara del dispositivo: utilizada para el escaneo de códigos de barras y captura de

imágenes de productos.

7. Decisiones de Diseño

El sistema iVenti ha sido desarrollado utilizando las siguientes tecnologías:

●  Flutter: framework principal para el desarrollo de la aplicación móvil.
●  PostgreSQL: sistema de gestión de base de datos relacional utilizado para el

almacenamiento centralizado de la información.

●  APIs REST: utilizadas para la comunicación entre el cliente móvil y el servidor.

La elección de Flutter se debe a su capacidad de desarrollar aplicaciones móviles

multiplataforma con una sola base de código, lo que mejora la eﬁciencia del desarrollo.

PostgreSQL fue seleccionado por su robustez, escalabilidad y capacidad de manejar

relaciones complejas entre datos, lo cual es fundamental en un sistema de inventario y

ventas.

La arquitectura basada en cliente-servidor permite una separación clara de

responsabilidades, facilitando el mantenimiento y escalabilidad del sistema.

8. Restricciones Técnicas

El sistema iVenti presenta las siguientes restricciones técnicas:

●  El sistema requiere conexión a internet para el funcionamiento de la mayoría de sus

funcionalidades, debido a la dependencia de servicios en la nube.

●  El acceso al sistema está limitado a dispositivos móviles compatibles con Flutter,

principalmente tablets y smartphones Android.

●  El sistema depende de servicios externos como PostgreSQL en la nube, por lo que su

disponibilidad está sujeta a estos proveedores.

●  No se contempla funcionamiento completo oﬄine, únicamente almacenamiento local

parcial como soporte.

●  La arquitectura no incluye múltiples servidores ni balanceo de carga avanzado,

estando orientada a un entorno de pequeña escala.
