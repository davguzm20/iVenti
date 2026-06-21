# Descripción del Proceso y CUNs


1. Introducción

Este documento deﬁne las necesidades del negocio de la empresa cliente Multiservicios

Golden S.A. y establece el contexto en el que se desarrollará la solución tecnológica iVenti.

Su ﬁnalidad es describir el proceso actual, los objetivos del negocio y el alcance general del

sistema desde una perspectiva no técnica.

El documento cubre la operación actual del negocio, sus limitaciones y las mejoras esperadas

mediante el uso de un sistema de gestión de inventario y ventas. Se enfoca en un entorno de

negocio pequeño con operaciones presenciales, donde una sola persona administra

productos, ventas y control de stock.

●

●

iVenti - Solución tecnológica de gestión de inventario y ventas.

Inventario - Conjunto de productos disponibles para la venta.

●  Stock - Cantidad disponible de un producto.
●  Venta - Transacción en la que se registran productos vendidos a un cliente.
●  Stakeholder - Persona interesada en el sistema o afectada por su uso.

2. Descripción del Negocio

Multiservicios Golden S.A. es un negocio minorista que comercializa diversos productos

como abarrotes, frutas, útiles escolares, artículos de limpieza y ferretería. La operación del

negocio es local y depende principalmente de la gestión manual realizada por el encargado.

Las actividades diarias incluyen el control de productos, registro de ventas y reposición de

stock. Actualmente, estas tareas se realizan sin apoyo de herramientas digitales, lo que limita

la eﬁciencia operativa.

El negocio presenta diﬁcultades en el control y seguimiento de sus operaciones debido a la

ausencia de un sistema de gestión. No existe visibilidad clara del inventario disponible, lo que

genera pérdidas por desabastecimiento o acumulación innecesaria de productos.

El control de productos con fecha de vencimiento es limitado, aumentando el riesgo de

caducidad. Las ventas no se registran formalmente, lo que impide analizar ingresos o tomar

decisiones basadas en información real. Además, el proceso manual hace que las

operaciones sean lentas y propensas a errores.

●  Reducir pérdidas por vencimiento de productos
●  Disminuir errores en registro de ventas
●  Mejorar la visibilidad del inventario en tiempo real
●  Reducir el tiempo de registro de ventas

3. Stakeholders

Los stakeholders del negocio son las personas o entidades que participan en las operaciones

o se ven afectadas por ellas:

●  Propietaria del negocio: responsable de la gestión diaria, incluyendo ventas, control

de inventario y toma de decisiones.

●  Propietaria del negocio:

Necesita mantener control sobre el inventario, registrar las ventas de manera

ordenada y disponer de información conﬁable para la toma de decisiones.

4. Procesos del Negocio

1. Atención y registro de ventas

●  Entrada:

Solicitud de productos por parte del cliente.

●  Actividades:

○  Veriﬁcar la disponibilidad del producto en el inventario físico.
○  Entregar el producto al cliente.
○  Calcular el monto total de la venta.
○  Registrar la venta de forma manual.
○  En caso de venta al crédito, registrar la deuda del cliente.

●  Salida:

Venta realizada y registrada / deuda registrada en caso de crédito.

2. Control y reposición de inventario

●  Entrada:

Observación del estado del inventario (cantidad de productos disponibles).

●  Actividades:

○  Revisar periódicamente el inventario de productos.
○

Identiﬁcar productos con bajo stock o alta rotación.

○  Determinar la necesidad de reposición.
○  Solicitar productos a proveedores.

●  Salida:

Pedido de reposición generado.

5. Reglas del Negocio

●  Toda venta realizada debe ser registrada.
●  Las ventas pueden realizarse al contado o al crédito.
●  Las ventas al crédito deben generar un registro de deuda asociado a un cliente.
●  El inventario debe ser revisado de forma periódica para identiﬁcar productos con bajo

stock.

●  Los productos con bajo stock deben ser considerados para reposición.
●  Los productos con fecha de vencimiento deben ser revisados antes de su caducidad.
●  Todo producto recibido debe ser veriﬁcado antes de ser puesto a la venta.

●  La gestión del negocio es realizada por una sola persona.
●  No se realizan ventas en línea.
●  No se manejan procesos contables avanzados.
●  No existen múltiples sucursales.

6. Alcance del Sistema

La solución propuesta apoyará las operaciones principales del negocio relacionadas con la

gestión de inventario y el registro de ventas. Permitirá mejorar el control de los productos

disponibles, el seguimiento de las transacciones realizadas y el acceso a información

relevante para la toma de decisiones.

La solución no contempla la gestión de ventas en línea ni la integración con plataformas

externas de comercio electrónico. Tampoco incluye funcionalidades de facturación

electrónica, sistemas contables avanzados ni la administración de múltiples sucursales.
