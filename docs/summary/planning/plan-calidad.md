# Plan de Aseguramiento de Calidad


1. INTRODUCCIÓN

Las revisiones realizadas por el Equipo de Aseguramiento y Control de la Calidad para la App
Móvil de Gestión de Inventario tendrán como herramientas principales los Checklists de Calidad,

implementados para las revisiones y auditorías de calidad de proceso, donde se veriﬁca el
cumplimiento de los estándares de calidad, y del producto de software que involucra revisiones
en todos sus estados de evolución, es decir, especiﬁcaciones, diseño, codiﬁcación, entre otros.

Las actividades contenidas dentro del aseguramiento de la calidad son:

1.1. Aseguramiento del Producto

Las principales tareas del aseguramiento del producto son:

-  Se debe asegurar que la aplicación móvil y su documentación técnica (diagramas de
casos de uso, diccionario de datos y manuales) cumplan con las exigencias de los

contratos de Desarrollo y Mantenimiento y se adhieran a los planes de la organización.

-  Se debe asegurar, antes de la entrega del producto software, que se han satisfecho
completamente los requerimientos establecidos dentro del alcance del producto.

1.2. Aseguramiento del Proceso

Las principales tareas del aseguramiento del proceso son:

-  Se debe asegurar que el proceso del ciclo de vida del software se cumpla de acuerdo a

los procedimientos, procesos y contratos a los cuales están adheridos.

-  Se debe identiﬁcar la aplicación de buenas prácticas internas de ingeniería de software
(construcción, pruebas, nivel de reutilización, integración y desacoplamiento funcional).

-  Se debe asegurar que las mediciones del proceso, producto están de acuerdo a las

normas y procedimientos establecidos en la organización.

Se han establecido los hitos y buenas prácticas para el ciclo de vida del software y las
herramientas de control que considerará a los métodos de aseguramiento de la calidad que

aplicará en cada hito establecido.

2. OBJETIVO

Establecer las normas y procedimientos necesarios para lograr que la Aplicación Móvil de
Gestión de Inventario, implementada por la consultora "BestTech S.A.", satisfaga las necesidades

de la empresa "Multiservicios Golden S.A.", garantizando que el producto ﬁnal sea robusto,
seguro y fácil de usar para los operarios de almacén.

3. ALCANCE

El presente plan de aseguramiento y control de la calidad abarca todas las fases de desarrollo
del proyecto de gestión de inventario, desde la etapa de concepción hasta la entrega ﬁnal del

producto software.

La metodología comprende:

-  Abarca los aspectos relacionados al Proceso de Aseguramiento de la Calidad, para

proporcionar la seguridad apropiada de que el producto y sus procesos de desarrollo

sean conformes con sus requerimientos especíﬁcos y se adhieren a los planes
establecidos.

-  Abarca los aspectos relacionados al Proceso de Control de Calidad que contiene las

actividades de veriﬁcación y validación tanto de los entregables de software elaborados
por los procesos de desarrollo del producto.

4. EVALUACIONES PARA EL ASEGURAMIENTO Y

CONTROL DE CALIDAD DEL SOFTWARE DEL PRODUCTO

Mediante las pruebas que se realicen en el control de calidad por parte del equipo a la App de
Gestión de Inventario, tales como: Revisión de código, pruebas funcionales y pruebas de

seguridad, se validarán los criterios principales para los Factores de Calidad.

Factores de
Calidad

Criterios

Pruebas de control de
calidad

Funcionalidad

-  Registro exacto de entradas y salidas

-  Prueba funcional de

de productos.

-  Correcta lectura de códigos

-

(QR/Barras) o ingreso manual.
Interoperabilidad con la base de datos
centralizada.

caja negra.
-  Prueba de

autenticación y
validación de acceso
único.

-  Gestión correcta de ventas a crédito y

-  Prueba de integración

cálculo de deudas pendientes.

-  Generación y exportación correcta de

reportes de inventario y ventas.

Fiabilidad

Usabilidad

-  Precisión: Los saldos de stock deben
ser exactos tras cada transacción.
-  Tolerancia a fallos: Manejo de errores

si el servidor no responde.

-  Recuperación: Persistencia de datos si
la app se cierra inesperadamente.

-  Aprendizaje: Un operario nuevo debe
entender cómo registrar un ítem en
menos de 5 min.

-  Operatividad: Botones grandes y

legibles para entornos de almacén.
-  Atracción: Diseño limpio que facilite la

lectura de códigos SKU.

(App con BD).

-  Prueba funcional de
gestión de créditos.
-  Prueba funcional de

generación y
exportación de
reportes.

-  Prueba funcional de

cálculos.

-  Revisión de código

(Manejo de
excepciones).

-  Prueba de estrés de

conexión.

-  Revisión de Prototipo

(UI/UX).

-  Prueba funcional de

navegación.

-  Prueba de usabilidad
mediante observación
directa y ejecución
guiada de tareas.

Eﬁciencia

-  Programación: Código optimizado
para evitar lentitud en la carga de
listas.

-  Recursos: Consumo moderado de
batería y datos móviles durante la
sincronización.

-  Revisión de código

fuente.
-  Prueba de

rendimiento (Tiempo
de respuesta de
consultas SQL).

Cuando realicemos las revisiones debemos tener en cuenta estos niveles de error  que se
deﬁnen a continuación.

Nivel de error

Descripción

Leve

Grave

Muy Grave

Errores de forma y de bajo impacto en el software.

No se realizan transacciones válidas.

Se realizan transacciones inválidas, afectando la integridad de la
información.

En el caso de ser error “Leve”, se tomarán acciones inmediatas, corrigiéndose dicho error. En
caso de ser “Grave” o “Muy grave” se rehace el trabajo, dejando constancia en los checklist

respectivos.

5. EVALUACIONES DE ASEGURAMIENTO Y CONTROL DE

CALIDAD - PROCESO

Para la evaluación objetiva de los procesos seleccionados se veriﬁcarán si se están llevando a
cabo el cumpliendo de los estándares, normas y procedimientos. Para los cual tendremos los

siguientes Mecanismos de Control:

-  Reporte de la revisión.
-  Reporte de no-conformidades.
-  Acciones correctivas.

Asimismo debemos de:

1.  Promover un ambiente que fomente en los empleados identiﬁcar e informar problemas

de calidad. Ejemplos:

a.  ¿Qué será revisado?
b.  ¿Cuándo o con qué frecuencia será revisado un proceso?
c.  ¿Cómo será el procedimiento de revisión?
d.  ¿Quién deberá estar involucrado en la revisión?

2.  Usar criterios documentados en las evaluaciones.
3.
Identiﬁcar no-conformidades en las evaluaciones.
4.
Identiﬁcar lecciones aprendidas para mejorar el proceso revisado

5.1. Evaluación objetiva de los entregables

Se evaluará objetivamente los entregables intermedios, productos generados y  servicios
seleccionados, veriﬁcando si se están produciendo de acuerdo a los  estándares, normas y

procedimientos. Para los cuales tendremos los siguientes  Mecanismos de Control:

-  Reporte de la revisión.
-  Reporte de no-conformidades.
-  Acciones correctivas.

Asimismo debemos de:

1.  Seleccionar entregables intermedios y productos a ser revisados, basados en un criterio

establecido.

2.  2. Deﬁnir un criterio claro para la evaluación de los entregables intermedios y productos.
Mantener actualizado el criterio. Basarse en los objetivos de negocio.  Por ejemplo:

a.  ¿Qué será revisado durante la evaluación de un entregable?
b.  ¿Cuándo o con qué frecuencia será revisado un entregable?
c.  ¿Cómo será el procedimiento de revisión?
d.  ¿Quién deberá estar involucrado en la revisión?

3.  Usar un criterio documentado en las evaluaciones.
4.  Evaluar los entregables antes que sean entregados al usuario.
5.  Evaluar entregables en hitos seleccionados durante su desarrollo.
6.  Identiﬁcar el tipo de no-conformidad durante las evaluaciones.
7.

Identiﬁcar lecciones aprendidas para mejorar el proceso y sus entregables.

5.2. Asegurar la solución de las no-conformidades

Se asegurará la solución de las no-conformidades e informar los problemas de calidad a la
gerencia. Para los cual tendremos los siguientes Mecanismos de Control:

-  Reporte de acciones correctivas.
-  Reporte de evaluación.
-

Informe de calidad (tendencias, causas de no-conformidad).

Asimismo debemos de:

1.  Resolver las no-conformidades dentro del proyecto. Ejemplo:

a.  Resolver la no-conformidad.
b.  Cambiar el proceso, estándar o procedimiento infringido.
c.  Autorizar la no-conformidad.

2.  Documentar las no-conformidades cuando no pueden resolverse dentro del proyecto.
3.  Escalar las no-conformidades cuando no pueden resolverse dentro del proyecto.
4.  Analizar las no-conformidades para ver si hay patrones en los problemas de calidad.
5.  Asegurarse que a las partes afectadas e involucradas se les informe de los resultados de

las evaluaciones oportunamente.

6.  Revisar periódicamente las no-conformidades no resueltas con el gerente designado.
7.  Hacer seguimiento a las no-conformidades hasta que sean resueltas.

6. ACTIVIDADES DE VERIFICACIÓN Y VALIDACIÓN

Las principales tareas de la Veriﬁcación dentro del control de calidad establecidos para el
desarrollo de la App Móvil de Gestión de Inventario son las siguientes:

-  Veriﬁcación del proceso: Desde la planiﬁcación (identiﬁcación del entorno de desarrollo
móvil y servidor), ejecución, control, seguimiento y cierre de los procesos de desarrollo

del software de inventario.

-  Veriﬁcación de los requerimientos: Teniendo en cuenta los criterios de viabilidad

técnica, consistencia de los datos de stock, efectividad y seguridad de la información.

-  Veriﬁcación del diseño: Teniendo en cuenta la trazabilidad de los requerimientos y

cumplimiento de los estándares de diseño de interfaz móvil, considerando la ejecución
correcta de eventos de entrada (escaneo de códigos), salida (reportes de stock),
interfaces, acoplamiento y niveles de contención de errores.

-  Veriﬁcación del código: Teniendo en cuenta la trazabilidad hacia el diseño y los

requerimientos, cumplimiento de los estándares de programación deﬁnidos para el
proyecto, asegurando la correcta autenticación del usuario principal y la integridad de las
operaciones sobre la base de datos.

-  Veriﬁcación de la integración: Teniendo en cuenta que los componentes de la aplicación
móvil estén correctamente integrados con la base de datos relacional deﬁnida para el
entorno local del sistema, bajo un plan de integración técnica.

-  Veriﬁcación de la documentación: Asegurar que toda la documentación técnica

(Diagramas UML, Diccionario de Datos, MER) esté completa, preparada a tiempo para las
entregas y bajo procesos de Gestión de la Conﬁguración

Actividades de Validación, las principales tareas de la validación dentro del control de  calidad,
sirven para determinar si los requerimientos y el producto ﬁnal cumplen con el uso especíﬁco

previsto dentro del alcance deﬁnido. Estas actividades apoyan la aceptación ﬁnal del producto y
se realizan durante todo el proceso.

Las principales actividades de validación son:

-  Determinación del esfuerzo de validación del producto: Deﬁnir cuántos recursos y

tiempo se dedicarán a probar la app en dispositivos reales.

-  Validación de los requerimientos de pruebas: Creación de casos de prueba especíﬁcos

y estimación de resultados posterior a la ejecución de las pruebas.

-  Validación de las especiﬁcaciones funcionales, técnicas y de seguridad: Conﬁrmar que

el sistema realiza correctamente el proceso de autenticación del usuario principal,

mantiene la integridad de los datos y ejecuta correctamente los cálculos de stock,
deudas y reportes.

-  Ejecución de las pruebas: Realización de pruebas unitarias, integrales y de aceptación

ﬁnal enmarcadas en el proceso de desarrollo.

7. HITOS y PUNTOS DE CONTROL

A continuación se detallan los Hitos (PCM) deﬁnidos, y los Puntos de Control (PCM)  por cada
fase:

7.1. Fase de Incepción

-  PCM0: Revisar y validar el levantamiento de Requerimientos Funcionales y No

Funcionales de la App Móvil de Gestión de Inventario.

7.2. Fase de Elaboración

-  PCM1: Revisar la consistencia y trazabilidad de la Documentación Técnica y de

Requerimientos, veriﬁcando que la arquitectura, almacenamiento y restricciones técnicas

descritas en el proyecto no presenten contradicciones respecto al SRS y demás
documentos oﬁciales.

7.3. Fase de Construcción

-  PCM2: Veriﬁcar la realización de las Pruebas Unitarias en los módulos críticos del

sistema, incluyendo registro de stock, cálculos de saldos, gestión de ventas a crédito y

generación de reportes.

-  PCM3: Revisar el Acta de Pase a Pruebas (QA) y veriﬁcar que el aplicativo esté
correctamente conﬁgurado y operativo en el entorno deﬁnido para el proyecto.

-  PCM4: Veriﬁcar la ejecución de las Pruebas Funcionales (Caja Negra) sobre los módulos

críticos del sistema: inventario, ventas a crédito y generación de reportes.

-  PCM5: Veriﬁcar las Pruebas de Sistemas y Seguridad relacionadas con autenticación del
usuario principal, integridad de datos y manejo correcto de errores en la base de datos.
-  PCM6: Revisar que la documentación técnica esté actualizada conforme a los cambios

realizados en el código.

7.4. Fase de Transición

-  PCM7: Revisar el Acta de Conformidad y Pase a Producción, validando que el producto

software cumple con el objetivo de negocio y está listo para la sustentación ﬁnal.

8. HERRAMIENTAS DE CONTROL Y TÉCNICAS A

UTILIZARSE

Con la ﬁnalidad de veriﬁcar el cumplimiento del Aseguramiento de la Calidad de la App de
Gestión de Inventario, se utilizarán las siguientes herramientas y técnicas:

-  Checklist o Lista de Control: Es nuestra herramienta principal de veriﬁcación. Se

utilizarán listas estructuradas con preguntas clave para cada componente.

-  Ejemplo aplicado: "¿Se validó que el campo 'Stock' no acepte valores negativos?",
"¿El diagrama MER incluye la relación entre 'Producto' y 'Categoría'?". Se usarán
tanto en la revisión de documentos técnicos como en el producto software ﬁnal.

-  Auditorías de Calidad: Realizaremos revisiones estructuradas para determinar si el

desarrollo de la app cumple con los requisitos del curso y las necesidades del negocio. El
objetivo es detectar procesos ineﬁcientes en la codiﬁcación o en el diseño de la base de
datos para reducir el costo de corrección y asegurar la aceptación del sistema por los
usuarios de almacén.

-  Análisis del Proceso: Examinaremos las restricciones experimentadas durante el

desarrollo (ej. problemas de conexión con el servidor en la nube DBaaS). Se aplicará el
Análisis Causal para determinar por qué ocurren ciertos defectos recurrentes en la
sincronización de datos y así crear acciones preventivas que eviten que el error se repita
en otros módulos.

-

Inspección: Consiste en el examen físico y lógico de los entregables para determinar si
cumplen con las normas. Realizaremos revisiones por pares (peer reviews), donde un
integrante del equipo revisa el código o diagrama de otro, midiendo la cantidad de
defectos encontrados antes de la entrega oﬁcial.

-  Revisión de Reparación de Defectos: Una vez identiﬁcado un error en el inventario, el

encargado de calidad realizará una revisión adicional para asegurar que el defecto haya
sido reparado siguiendo las especiﬁcaciones. Todas estas revisiones serán registradas
obligatoriamente en el formato de Checklist de Producto.

-  Pruebas de Usabilidad: Se realizarán sesiones de observación directa y ejecución guiada
de tareas con usuarios simulados o integrantes del equipo, evaluando la facilidad de
navegación, comprensión de funciones y eﬁciencia en el uso de la aplicación móvil.

9. RESPONSABLES

A continuación se detalla la Organización que realizará el Aseguramiento de la Calidad en la App
de Gestión de Inventario. Para poder cumplir con lo establecido en la metodología de

aseguramiento y control de calidad, se ha organizado este equipo cuyo organigrama es la
siguiente:

10. PROCEDIMIENTO DE ACCIONES PREVENTIVAS

El objetivo es investigar, analizar e implementar controles para asegurar que se tomen acciones
preventivas en forma oportuna frente a cualquier no conformidad potencial, evitando fallos

críticos en el control de stock o pérdida de datos en la aplicación móvil.

Se han deﬁnido los siguientes tipos de acciones preventivas para el proyecto:

10.1. Capacitación

-  Realizar sesiones internas de revisión sobre el uso del motor de base de datos

PostgreSQL para evitar errores de integridad y consistencia en las operaciones de

inventario.

-  Capacitar al equipo en estándares de diseño UI/UX móvil para evitar rechazos por

usabilidad.

10.2. Documentación

-  Mantener actualizado el Diccionario de Datos y el Manual de Instalación del entorno del

sistema para evitar inconsistencias durante el despliegue y operación ﬁnal.

-  Documentar cada error encontrado en las pruebas unitarias para que no se repita en

módulos similares.

10.3. Gestión

-  Realizar reuniones de seguimiento semanales (Sprints) para identiﬁcar riesgos antes de

que se conviertan en errores "Graves".

-  Asegurar que las copias de seguridad del código fuente estén en un repositorio de

GitHub para prevenir pérdida de avance técnico.

10.4. Sugerencias

-  Habilitar un canal de comunicación rápida (WhatsApp) para que cualquier integrante del

equipo pueda sugerir mejoras inmediatas al detectar una vulnerabilidad en el proceso de

desarrollo.

11. CRONOGRAMA DE ACTIVIDADES
