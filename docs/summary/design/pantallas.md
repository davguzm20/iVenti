# Pantallas del Sistema


1. Introducción

El presente documento tiene como propósito describir el diseño de la interfaz del sistema,

incluyendo la estructura de sus pantallas, navegación y componentes principales, con base

en el prototipo desarrollado.

Este documento abarca el diseño de las principales funcionalidades del sistema, incluyendo:

●

Inicio de sesión y registro

●  Gestión de inventarios
●  Gestión de ventas
●  Generación de reportes

No incluye la implementación técnica ni la lógica interna del sistema.

●  Documento de Especiﬁcación de Requisitos de Software (SRS)
●  Prototipo de interfaz (Canva)

2. Lineamientos de Diseño

El diseño del sistema se basa en los siguientes principios:

●  Simplicidad: Interfaces limpias y fáciles de entender.
●  Claridad: Elementos visuales comprensibles y bien etiquetados.
●  Consistencia: Uso uniforme de colores, botones e iconos en todas las pantallas.
●  Accesibilidad: Navegación intuitiva para distintos tipos de usuarios.

El sistema utiliza un diseño sencillo:

●  Colores: Predominio de colores neutros con acentos en tonos llamativos para

acciones importantes.

●  Tipografía: Fuente legible, sin serifas, adecuada para pantallas digitales.
●

Iconografía: Uso de íconos simples (lupa, +, lápiz, papelera) para facilitar la interacción.

3. Estructura de Navegación

Inicio de sesión → Pantalla principal → Inventario / Ventas / Reportes

4. Pantallas del Sistema

Sección: Inicio de Sesión

Esta pantalla integra las funcionalidades de inicio de sesión y registro de nuevos usuarios.

Permite al usuario autenticarse mediante su correo electrónico y crear una cuenta en caso de

no estar registrado.

●  Campo correo electrónico: Ingreso del email del usuario.
●  Botón "Conﬁrmar": Permite continuar con el siguiente paso.

Sección: Veriﬁcación de código

Permite a los usuarios ya registrados acceder al sistema.

●  Campo código de veriﬁcación: Ingreso del código recibido.
●  Botón "Continuar": Conﬁrma el código ingresado.

Sección: Creación de PIN

Permite deﬁnir el método de acceso al sistema.

●  Campo PIN: Ingreso de un PIN de 6 dígitos.
●  Botón "Guardar": Finaliza el registro.

Sección: Iniciar sesión en una cuenta ya registrada

Permite iniciar sesión una vez que se haya registrado el correo electrónico con éxito.

●  Campo PIN: Ingreso de un PIN de 6 dígitos.
●  Botón "Conﬁrma": Iniciar sesión.

Sección: Lista de productos

Muestra todos los productos registrados en el inventario.

●  Visualización de productos registrados
●  Botón de búsqueda (ícono de lupa)
●  Botón de ﬁltro (por categoría o stock)
●  Botón “+” para agregar nuevo producto

Nota: En este caso se repitió el mismo producto para simular más p

Sección: Registro de producto

Permite crear un nuevo producto en el inventario y categorías.

●  Campos obligatorios: nombre, unidad de medida, stock mínimo, precio
●  Campos opcionales: imagen, código de barras, categorías, stock máximo
●  Botón conﬁrmar / cancelar

Sección: Gestión de producto

Permite modiﬁcar o eliminar productos existentes y administrar los lotes de cada producto.

●  Botón editar (ícono de lápiz en un cuadro)
●  Botón añadir (añade un lote)

Sección: Búsqueda y ﬁltrado

Permite encontrar productos especíﬁcos.

●  Búsqueda por nombre
●  Filtro por categoría
●  Filtro por stock bajo

Sección: Mis ventas

Permite visualizar las ventas y registrar una venta, así mismo, buscar o ﬁltrar las ventas

realizadas.

●  Botón “+” para iniciar una venta
●  Botón de ﬁltrar
●  Botón de búsqueda

Sección: Registro de venta

Permite crear una nueva venta.

●  Botón “+” para agregar un producto, mediante búsqueda o escaneo de código de

barras

●  Edición o eliminación de productos agregados

Sección: Gestión de clientes

Permite ver los clientes, es parte de un ﬁltro

●  Clientes y sus ventas asociadas

Sección: Detalle de venta

Permite visualizar la información de la venta realizada.

●  Visualización de productos vendidos
●  Opción de imprimir boleta

Sección: Búsqueda y ﬁltrado

Permite encontrar ventas registradas.

●  Búsqueda mediante texto
●  Filtro por tipo de pago (contado o crédito)
●  Filtro por rango de fechas

Sección: Gestión de pagos (crédito)

Permite administrar las deudas de ventas a crédito.

●  Cliente, permite visualizar la información del cliente
●  Pago parcial de deuda
●  Pago total de deuda
●  Actualización automática del estado (cancelado)

Sección: Reportes

Esta pantalla permite generar reportes en formato PDF sobre ventas, inventario, lotes y

productos próximos a vencer. Los reportes pueden ser visualizados, compartidos o impresos

por el usuario.
