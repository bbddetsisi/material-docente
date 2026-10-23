#import "@preview/ilm:2.1.1": *
#import "@preview/ccicons:1.0.1": *
#import "@preview/showybox:2.0.4": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/fontawesome:0.6.2": fa-triangle-exclamation, fa-file-pen, fa-envelope, fa-lightbulb
#show: codly-init.with()
// #show raw.where(lang: "text"): it => { text(font: "DejaVu Sans Mono", it.text) }

#codly(
  languages: (
    java: (name: "Java", icon: text(font: "Font Awesome 7 Brands", size: 1em, "\u{f4e4} "), color: rgb("#007AFF")),
    text: (name: "Texto", icon: text(font: "Font Awesome 7 Free", size: 1em, "\u{f0f6} "), color: rgb("#000000")),
    sql: (name: "SQL", icon: text(font: "Font Awesome 7 Free", size: 1em, "\u{f1c0} "), color: rgb("#000000")),
    sh: (name: "Terminal", icon: text(font: "Font Awesome 7 Free", size: 1em, "\u{f120} "), color: rgb("#000000")),
  )
)

#set text(lang: "es")
#set quote(block: true)

// Cajas con el mismo estilo que el enunciado del hito 1
#let caja-nota(titulo, cuerpo) = showybox(
  title-style: (weight: 900, color: blue.darken(40%), sep-thickness: 0pt, align: left),
  frame: (title-color: blue.lighten(80%), border-color: blue.darken(40%), thickness: (left: 2pt), radius: 0pt),
  title: titulo,
  cuerpo,
)

#let caja-aviso(titulo, cuerpo) = showybox(
  title-style: (weight: 1200, color: white, sep-thickness: 0pt, align: left),
  frame: (title-color: red.lighten(20%), border-color: red.darken(40%), thickness: (left: 2pt), radius: 0pt),
  title: titulo,
  cuerpo,
)

#let caja-pista(cuerpo) = showybox(
  title-style: (weight: 900, color: green.darken(50%), sep-thickness: 0pt, align: left),
  frame: (title-color: green.lighten(80%), border-color: green.darken(40%), thickness: (left: 2pt), radius: 0pt),
  title: [#fa-lightbulb() Precisiones],
  cuerpo,
)

#show: ilm.with(
  title: [Sistema de gestión de paquetería y logística ("LogiPack Express")],
  authors: "Bases de Datos",
  date: datetime(year: 2024, month: 03, day: 19),
  abstract: [
    Proyecto de la asignatura Bases de Datos\ Curso 2026-2027\ \ ETSI Sistemas Informáticos\ Universidad Politécnica de Madrid
  ],
  preface: [
    #align(left + bottom)[
      Sistema de gestión de paquetería y logística ("LogiPack Express") #sym.copyright 2025 por Raúl Lara Cabrera publicado bajo licencia #cc-by-nc-sa CC BY-NC-SA 4.0.

      Para consultar una copia de esta licencia, visita https://creativecommons.org/licenses/by-nc-sa/4.0
    ]
  ],
  // bibliography: bibliography("refs.bib"),
  figure-index: (enabled: true, title: "Índice de figuras"),
  table-index: (enabled: true, title: "Índice de tablas"),
  listing-index: (enabled: true, title: "Índice de listados"),
)

= Introducción y Objetivos
El objetivo de esta práctica es diseñar e implementar el sistema de base de datos relacional para *LogiPack Express*, una empresa nacional de mensajería y logística integral en plena expansión territorial y digital.

Como futuros ingenieros e ingenieras en informática, uno de los desafíos cotidianos más relevantes es la *capacidad de análisis, extracción y formalización de requisitos* a partir de entrevistas con clientes reales y documentación informal, donde la información se presenta desordenada, incompleta o sujeta a ambigüedades.

A lo largo del semestre abordaréis de forma práctica todas las fases del ciclo de vida de desarrollo de una base de datos relacional:

+ *Modelado Conceptual:* Obtención del Diagrama Entidad-Relación extendido (E-R).
+ *Modelado Lógico:* Transformación al Modelo Relacional, normalización y formalización de restricciones de integridad.
+ *Implementación y Consultas SQL Avanzadas:* Definición de esquemas DDL, diseño de restricciones de dominio/tabla y resolución de consultas analíticas complejas (DML).
+ *Programación en Servidor de Base de Datos:* Procedimientos almacenados, funciones, control transaccional explícito ($"ACID"$) y disparadores (*triggers*) para validaciones en tiempo real y auditoría.
+ *Integración con Aplicación Cliente:* Conexión del esquema a una interfaz gráfica de usuario en Java mediante JDBC, gestionando transacciones y excepciones desde el backend.

= Metodología de trabajo e hitos del proyecto
La práctica no requiere entregas parciales ni finales de documentación o código. El trabajo se desarrollará de manera continua y progresiva a lo largo de las *sesiones de laboratorio semanales*, guiado por el profesorado. La evaluación de la práctica se realizará *en un examen de prácticas* el mismo día del examen de teoría.

El avance se organiza en torno a tres *hitos formativos*:

- *Hito 1: Fase conceptual y lógica*
  - Análisis de los textos de los clientes y extracción de entidades, atributos, claves y relaciones.
  - Elaboración del Diagrama Entidad-Relación.
  - Transformación al Esquema Relacional con indicación explícita de claves primarias (`PK`) y foráneas (`FK`).

- *Hito 2: Implementación SQL y lógica procedimental*
  - Creación del script DDL de creación de tablas.
  - Carga de un dataset de prueba representativo con datos realistas para verificar volúmenes y tiempos de respuesta.
  - Resolución y optimización de la batería de consultas SQL.
  - Implementación y depuración de funciones, procedimientos almacenados transaccionales y disparadores (*triggers*).

- *Hito 3: Integración con la aplicación gráfica Java (JDBC)*
  - Creación de vistas SQL requeridas por la interfaz de usuario.
  - Conexión entre la base de datos y la aplicación Java GUI provista mediante JDBC.
  - Programación de bloques transaccionales en Java (`setAutoCommit(false)`, `commit()`, `rollback()`) para operaciones críticas de negocio y tratamiento de excepciones generadas por los disparadores del motor de bases de datos.

= Transcripción de las entrevistas con el cliente (*LogiPack Express*)
A continuación se presentan las notas directas tomadas por el equipo de análisis durante las reuniones de toma de requisitos con los distintos directores de área.

#showybox(
  title-style: (
    weight: 900,
    color: blue.darken(40%),
    sep-thickness: 0pt,
    align: left
  ),
  frame: (
    title-color: blue.lighten(80%),
    border-color: blue.darken(40%),
    thickness: (left: 2pt),
    radius: 0pt
  ),
  title: [#fa-file-pen() Notas de la Reunión 1: Área comercial y operaciones],
  [
    #quote(quotes: true, attribution: [Gonzalo (Director de Operaciones)])[
      Movemos miles de paquetes cada día entre nuestras sedes, centros intermedios y destinos finales. Necesitamos poder rastrear todo el ciclo de vida del paquete desde el segundo en que entra en nuestra red hasta que se entrega en mano o en taquilla.

      Nuestros clientes pueden ser particulares (necesitamos su DNI/NIE, nombre, apellidos, teléfono móvil, correo electrónico y dirección habitual) o empresas (con CIF, razón social, dirección fiscal, teléfono central, email de facturación y el nombre de una persona de contacto). A las empresas registradas les ofrecemos condiciones de pago agrupadas y tarifas con descuento en función de su volumen de envíos mensual.

      Un cliente puede crear un envío que contenga un único bulto o múltiples bultos agrupados bajo un mismo número de pedido global. A cada bulto o paquete individual le asignamos un código de seguimiento único universal (_tracking code_) con el formato canónico `LP-2026-XXXXX`. De cada paquete registramos su peso medido en báscula en kilos (_kg_), sus dimensiones físicas exactas (alto, ancho y largo en centímetros, _cm_), si el contenido está catalogado como frágil, si requiere mantenimiento de cadena de frío (transporte refrigerado) y el valor declarado en euros para la cobertura del seguro.

      Cada paquete tiene una dirección de origen y una de destino. En destino hay dos modalidades: entrega a domicilio particular o entrega en un punto de recogida o taquilla inteligente de nuestra red concertada. En caso de taquilla inteligente, debemos saber con exactitud en qué taquilla física se ha depositado y el código PIN de apertura de 6 dígitos autogenerado para el destinatario.

      La tarifa base de cada paquete se cobra comparando su peso real con su peso volumétrico, multiplicando por la zona de destino y sumando recargos por urgencia (Estándar 48h, Express 24h, Mismo Día). Además, si el cliente declara un valor de mercancía superior a 500€ y contrata seguro voluntario, se le cobra un recargo de prima del 2% sobre el valor total declarado.
    ]
  ]
)


#showybox(
  title-style: (
    weight: 900,
    color: blue.darken(40%),
    sep-thickness: 0pt,
    align: left
  ),
  frame: (
    title-color: blue.lighten(80%),
    border-color: blue.darken(40%),
    thickness: (left: 2pt),
    radius: 0pt
  ),
  title: [#fa-file-pen() Notas de la Reunión 2: Logística interna, almacenes y flota],
  [
    #quote(quotes: true, attribution: [Lucía (Jefa de Logística e Infraestructuras)])[
      Nuestra red se apoya en centros de distribución (grandes naves logísticas provinciales). Cada centro se identifica por un código alfanumérico único, nombre descriptivo, dirección física, provincia, superficie en $m^2$ y capacidad volumétrica máxima de almacenamiento temporal en metros cúbicos ($m^3$).

      El ciclo de vida de un paquete sigue una máquina de estados controlada: `Registrado` #sym.arrow `En Almacén Origen` #sym.arrow `En Tránsito` #sym.arrow `En Centro Intermedio` #sym.arrow `En Reparto` #sym.arrow `Disponible en Taquilla` #sym.arrow `Entregado` #sym.arrow `Devuelto a Origen` #sym.arrow `Incidencia`. No se puede saltar entre estados arbitrariamente. Para garantizar la trazabilidad legal y de calidad, cada cambio de estado debe persistirse de forma inmutable: fecha y milisegundo exacto, ubicación física o vehículo en el que se escanea, DNI del operario o repartidor responsable y un campo de observaciones textuales (por ejemplo, 'Embalaje ligeramente deteriorado', 'Cliente no responde al interfono').

      Los movimientos interprovinciales entre centros se gestionan mediante manifiestos de carga. Un manifiesto agrupa una lista cerrada de paquetes que viajan dentro de un camión desde un centro de origen a un centro de destino en una fecha y franja horaria programada.

      Nuestra flota cuenta con furgonetas de reparto de última milla y camiones pesados interurbanos. De cada vehículo guardamos matrícula, marca, modelo, volumen de carga útil en $m^3$, masa máxima autorizada (_MMA_) en _kg_, y situación operativa (`Disponible`, `En Ruta`, `En Mantenimiento`). Algunos vehículos son en propiedad y otros están en régimen de arrendamiento financiero o alquiler a corto plazo (guardando el coste diario de alquiler y la fecha de expiración del contrato).

      En cuanto a la plantilla, tenemos dos perfiles de campo fundamentales: mozos de almacén (vinculados a un centro concreto) y repartidores (asignados a un vehículo y a una zona geográfica o conjunto de códigos postales). De todos los empleados necesitamos DNI, nombre completo, teléfono corporativo, salario base anual y fecha de alta. De los repartidores registramos adicionalmente su número de permiso de conducción y fecha de renovación médica.
    ]
  ]
)

#showybox(
  title-style: (
    weight: 900,
    color: blue.darken(40%),
    sep-thickness: 0pt,
    align: left
  ),
  frame: (
    title-color: blue.lighten(80%),
    border-color: blue.darken(40%),
    thickness: (left: 2pt),
    radius: 0pt
  ),
  title: [#fa-file-pen() Notas de la Reunión 3: Facturación, reclamaciones y calidad del servicio],
  [
    #quote(quotes: true, attribution: [Marcos (Director Financiero)])[
      Con los particulares cobramos cada envío al momento del registro. Sin embargo, con las empresas asociadas trabajamos mediante facturación mensual agrupada: el último día natural de cada mes cerramos una factura con todos los paquetes remitidos por dicha empresa a lo largo de ese periodo.

      Cada factura tiene su número correlativo, fecha de expedición, base imponible neta, cuota de IVA (21%), total general y estado de cobro (`Pendiente`, `Cobrada`, `Vencida`). La factura desglosa en detalle cada paquete facturado: código de seguimiento, fecha de envío, coste unitario bruto, importe del descuento y neto.

      La escala mensual de descuento comercial para empresas es acumulativa: 10% si el cliente envió más de 50 paquetes en el mes, y un 15% si superó los 200 paquetes.

      En el plano de calidad, si un paquete se extravía, sufre roturas o se entrega con un retraso superior a 72 horas sobre el plazo pactado para su modalidad, el cliente emisor o receptor puede interponer una reclamación formal. Si el departamento de resolución la aprueba, se emite una orden de indemnización monetaria que puede deducirse en la siguiente factura o liquidarse por transferencia bancaria.
    ]

    #quote(quotes: true, attribution: [Elena (Responsable de operaciones y seguridad)])[
      Quiero recalcar tres directrices operativas infranqueables:

      + Límite de intentos de entrega: Un repartidor tiene autorizados un máximo de *2 intentos de entrega a domicilio*. Si en el segundo intento el destinatario continúa ausente, el paquete no vuelve a salir a reparto: pasa automáticamente a estado `Incidencia` con el motivo 'Segunda ausencia reiterada', reasignándose a la Taquilla Inteligente libre más próxima a la dirección del destinatario y notificándole el PIN.

      + Seguridad de carga: No se puede permitir bajo ningún concepto la sobrecarga de un vehículo. En el momento en que un mozo o repartidor asigna paquetes a una furgoneta o camión, la base de datos debe comprobar en tiempo real que *ni la suma de pesos (_kg_) ni la suma de volúmenes ($m^3$)* de la mercancía excedan los topes homologados del vehículo. Si se sobrepasa cualquiera de los dos, el sistema debe denegar la operación arrojando un error explicativo.

      + Inmutabilidad y Auditoría: Los registros históricos de cambio de estado son sagrados; está terminantemente prohibido que nadie (ni siquiera un usuario con permisos elevados de aplicación) actualice o borre una fila del historial. Debe haber una tabla de auditoría técnica que capture automáticamente usuario, terminal y timestamp ante cualquier intento de inserción o manipulación.
    ]
  ]
)

= Requisitos del sistema a extraer y desarrollar

A partir de la narrativa de los responsables de LogiPack Express, el estudiantado deberá modelar, implementar y validar la base de datos completa. A continuación se describen las tareas que hay que realizar para cumplir con los objetivos de la práctica.

== Modelado Conceptual
- *Diagrama Entidad-Relación Extendido:* Identificación rigurosa de entidades fuertes y débiles, atributos, claves, cardinalidades mínimas y máximas, relaciones reflexivas, atributos propios en relaciones N:M y jerarquías de especialización/generalización (con indicación de cobertura total/parcial y solapada/disjunta).
- *Dominio de datos:* Definición detallada de los tipos de datos, restricciones y reglas de negocio que aplican a cada atributo del sistema.
- *Semántica no contemplada:* Identificación de cualquier requisito funcional o de integridad que no pueda representarse en el modelo E-R y que deba trasladarse al modelo relacional o a la implementación SQL.

== Modelado Lógico
Una vez completado el modelo conceptual, se procederá a la transformación del mismo al modelo relacional, especificando las claves primarias y foráneas, así como las restricciones de integridad referencial y de dominio que no puedan representarse en el modelo E-R.

== Modelado Físico
El modelo físico se implementará en un motor de base de datos relacional (MySQL) mediante un script DDL que cree las tablas, relaciones y restricciones necesarias para garantizar la integridad de los datos y la eficiencia de las consultas. Además, hay que generar un conjunto de datos de prueba representativo que permita verificar el correcto funcionamiento del sistema.

= Cambio de planes en LogiPack Express
Durante el hito 1 habéis analizado las entrevistas con los responsables de LogiPack Express y habéis elaborado vuestro propio diagrama Entidad-Relación y su transformación al modelo relacional.

Mientras tanto, la dirección de LogiPack Express, con prisa por tener la nueva plataforma operativa antes de la campaña de Navidad, tomó una decisión por su cuenta: *subcontrató a una consultora externa*, _Relacional Consulting S.L._, para que realizase en paralelo el modelo Entidad-Relación y su paso a tablas. El resultado de ese trabajo es el *script SQL de creación de tablas* que se entrega con este enunciado.

#caja-nota(
  [#fa-envelope() Comunicado de la Dirección de Operaciones],
  [
    #quote(quotes: true, attribution: [Gonzalo (Director de Operaciones)])[
      Os agradecemos mucho el trabajo de análisis de estas semanas. Como sabéis, no podíamos permitirnos ningún retraso, así que encargamos a Relacional Consulting un modelo de datos completo, que ya ha sido revisado y aprobado por el comité técnico. Ese modelo pasa a ser *el modelo oficial de la compañía*: los equipos de operaciones, facturación y la aplicación de escritorio van a trabajar sobre él. A partir de ahora, todo el desarrollo (consultas, procedimientos, disparadores y vistas) debe hacerse sobre las tablas de la consultora.

      La consultora ha tomado algunas decisiones de simplificación para entregar a tiempo. Ya sabemos que no recoge al pie de la letra todo lo que os contamos en las reuniones; os pedimos que trabajéis con lo que hay y que, cuando algo no pueda obtenerse exactamente, aproximéis la respuesta con los datos disponibles.
    ]
  ]
)

Esta situación es muy habitual en la vida profesional: rara vez se parte de cero, y lo normal es heredar un modelo de datos diseñado por otras personas, con decisiones que no siempre compartimos. Saber leerlo, entender sus limitaciones y sacarle partido es una competencia tan importante como saber diseñarlo.

#caja-aviso(
  [#fa-triangle-exclamation() A partir de este hito se usa el modelo de la consultora],
  [
    Todas las consultas de este hito, y el resto de la práctica, deben resolverse sobre el script `logipack_express.sql` proporcionado, *sin modificar ni añadir tablas o columnas*. Vuestro modelo del hito 1 no se pierde: os servirá para entender el de la consultora y para detectar en qué se diferencian.
  ]
)

== Material proporcionado

#figure(
  table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Fichero*], [*Contenido*]),
    [`Logipack Express - Modelo Entidad-Relacion.png`], [Diagrama E-R extendido elaborado por la consultora (@fig-er).],
    [`logipack_express.sql`], [Script DDL de creación de las tablas (modelo relacional de la consultora).],
    [`logipack_express_datos.sql`], [Datos de prueba ficticios de los meses de julio a octubre de 2026.],
  ),
  caption: [Ficheros que acompañan a este enunciado],
)

Los scripts están probados en *MySQL 8.4*. Hay que cargarlos en este orden, sobre una base de datos vacía:

```sh
mysql -u usuario -p -e "CREATE DATABASE logipack CHARACTER SET utf8mb4"
mysql -u usuario -p logipack < logipack_express.sql
mysql -u usuario -p logipack < logipack_express_datos.sql
```

El script de tablas empieza borrando las tablas si existen, de modo que se puede volver a ejecutar en cualquier momento para dejar la base de datos en su estado inicial (después hay que volver a cargar los datos).

== El modelo de la consultora

#figure(
  rotate(-90deg, reflow: true, image("2627-logipack-express/modelo-er-consultora.png", width: 22cm)),
  kind: image,
  caption: [Diagrama Entidad-Relación de LogiPack Express elaborado por Relacional Consulting],
) <fig-er>

El modelo relacional resultante consta de 21 tablas, que se pueden agrupar así:

- *Clientes:* `cliente` (supertipo) con sus subtipos `particular` y `empresa`, que comparten la clave `nif_cif`.
- *Envíos y bultos:* un `envio` (identificado por `num_pedido`) lo crea un cliente y agrupa uno o varios `bulto`, identificados por su `codigo_seguimiento`. Cada bulto va hacia un `destino`.
- *Destinos:* `destino` (supertipo, identificado por su dirección y asociado a una `zona`) con sus subtipos `domicilio_particular` y `punto_recogida`. Cada punto de recogida tiene varios casilleros (`locker`, entidad débil).
- *Red logística:* `centro_distribucion`, `zona`, `vehiculo` (con el subtipo `alquilado` para los vehículos en régimen de alquiler), `manifiesto` y la tabla N:M `manifiesto_bulto`.
- *Plantilla:* `empleado` (supertipo) con sus subtipos `mozo_almacen` (vinculado a un centro) y `repartidor` (con una zona y un vehículo asignados).
- *Facturación y calidad:* `factura` (entidad débil de `empresa`, numerada por empresa) y `reclamacion`.
- *Trazabilidad:* `transicion` (entidad débil de `bulto`) guarda el historial de cambios de estado de cada bulto.

=== La tabla `transicion`
Es la tabla central para la mayoría de las consultas. Cada fila es un cambio de estado de un bulto, con clave primaria `(codigo_seguimiento, fecha_hora)`. La columna `fecha_hora` es de tipo `DATETIME(3)`, es decir, guarda milisegundos. Además del estado y unas observaciones opcionales, una transición puede referenciar:

- `codigo_centro`: el centro de distribución en el que se escanea el bulto (o desde el que sale a reparto).
- `matricula_vehiculo`: el vehículo en el que viaja o se reparte.
- `direccion_destino`: el destino en el que se produce el movimiento (el domicilio en una entrega o una incidencia, o el punto de recogida en un depósito en taquilla).
- `dni_empleado`: el empleado que realiza el escaneo. Es nulo cuando el movimiento no lo hace ningún empleado (por ejemplo, el alta del envío o la recogida en taquilla por el destinatario).

Los valores posibles de `estado` son exactamente: `'Registrado'`, `'En Almacén Origen'`, `'En Tránsito'`, `'En Centro Intermedio'`, `'En Reparto'`, `'Disponible en Taquilla'`, `'Entregado'`, `'Devuelto a Origen'` e `'Incidencia'`. Cuando una incidencia se debe a que el destinatario no estaba en casa, la observación es exactamente `'Cliente ausente'`.

== Datos de prueba
El script de datos contiene un histórico ficticio de unos tres meses y medio de actividad:

- 111 clientes (95 particulares y 16 empresas).
- 6 centros de distribución, 15 zonas y 30 puntos de recogida con 400 casilleros.
- 50 empleados (21 mozos de almacén y 29 repartidores) y 54 vehículos, 23 de ellos alquilados.
- Unos 2.200 envíos con 2.900 bultos, 1.100 manifiestos y 17.300 transiciones.
- Las facturas de julio y agosto de 2026 ya están emitidas. Septiembre está *sin facturar*.

Los bultos siguen, en general, la secuencia de estados de la máquina de estados, pero, como en cualquier base de datos real, hay errores y situaciones anómalas: paquetes parados, escaneos incoherentes, taquillas sin recoger... Las consultas de este hito sirven precisamente para encontrarlos.

=== Fecha de referencia <sec-ahora>
Los datos tienen fechas fijas, así que *no se debe usar `NOW()`* en las consultas. El "momento actual" de los datos es el *15 de octubre de 2026 a las 21:30:00*. Al abrir cada sesión, definid esta variable y usadla siempre que una consulta dependa de la fecha actual:

```sql
SET @ahora = CAST('2026-10-15 21:30:00' AS DATETIME);
```

Con esta fecha de referencia:

- El *mes anterior* es septiembre de 2026 (del 1 al 30, ambos incluidos).
- El *último trimestre* es el tercer trimestre natural: de julio a septiembre de 2026.
- Las transiciones con fecha posterior a `@ahora` (hay alguna planificada) no se tienen en cuenta.

Las variables de sesión se pierden al cerrar la conexión; si volvéis a conectar, hay que definirlas de nuevo.

=== Fórmula de tarifas <sec-tarifa>
Las entrevistas describen cómo se calcula el coste de un bulto, pero no fijan el precio base. Para todas las consultas que necesiten el coste de un bulto se usará esta fórmula:

$
  "peso volumétrico" &= ("alto" dot "ancho" dot "largo") / 5000 quad ("dimensiones en cm") \
  "peso tasable" &= max("peso real", "peso volumétrico") \
  "importe" &= "peso tasable" dot 1,50 "€/kg" dot "factor de urgencia" + "recargo de seguro"
$

donde el factor de urgencia es 1,5 si el bulto es urgente y 1,0 si no lo es, y el recargo de seguro es el 2 % del valor declarado si el bulto tiene seguro y su valor declarado supera los 500 €. El importe de cada bulto se redondea a dos decimales.

= Consultas SQL
Se implementarán y validarán las siguientes consultas sobre el modelo de la consultora. Para cada una se incluye el enunciado original, tal y como lo formuló LogiPack Express, y unas precisiones que lo adaptan al modelo y a los datos disponibles.

Indicaciones generales:

- Cada consulta debe resolverse con *una única sentencia `SELECT`*. Se pueden usar subconsultas, expresiones de tabla comunes (`WITH`) y funciones de ventana (`ROW_NUMBER`, `LAG`, `LEAD`...), disponibles desde MySQL 8.
- Las consultas que dependan del momento actual deben usar `@ahora` (@sec-ahora).
- Usad nombres de columna descriptivos (`AS`) y un orden de salida razonable.
- Comprobad los resultados: pensad qué debería salir antes de ejecutar y revisad a mano algunos casos concretos.

== Consulta 1. Trazabilidad temporal
Dado un código de seguimiento de paquete (parámetro de entrada), listar su historial completo de estados ordenado cronológicamente. Calcular y mostrar la duración exacta (en días, horas y minutos) que el paquete permaneció en cada estado anterior hasta el siguiente movimiento.

#caja-pista[
  - El parámetro se define como una variable de sesión, por ejemplo `SET @codigo = 'LP-2026-10463';`.
  - Para cada transición se mostrará: fecha y hora, estado, ubicación (el destino, el vehículo o el centro, el que esté informado), nombre del empleado, observaciones y la duración en ese estado.
  - El último estado (el actual) no tiene duración.
]

== Consulta 2. Ranking de productividad de repartidores
Obtener el Top 5 de repartidores más eficientes del mes anterior por cada provincia. El cálculo se ponderará por: total de entregas con éxito en el primer intento y el menor tiempo medio transcurrido entre el pase a estado `En Reparto` y el estado `Entregado`.

#caja-pista[
  - Se consideran las transiciones `'Entregado'` de septiembre de 2026 hechas por un repartidor. Una entrega tiene éxito en el primer intento si el bulto no tiene ninguna `'Incidencia'` anterior a la entrega.
  - El tiempo de cada entrega va desde la última transición `'En Reparto'` anterior a la entrega hasta la entrega.
  - La provincia del repartidor es la del centro de distribución registrado en esa transición `'En Reparto'`.
  - La puntuación de cada repartidor combina ambos criterios:
    $ "puntuación" = 0,7 dot E / E_max + 0,3 dot T_min / T $
    donde $E$ es el número de entregas del repartidor, $E_max$ el máximo de entregas de un repartidor de su provincia, $T$ su tiempo medio de entrega y $T_min$ el menor tiempo medio de un repartidor de su provincia.
  - Salida: provincia, puesto, DNI, nombre, matrícula del vehículo, número de entregas, tiempo medio de entrega y puntuación.
  - En varias provincias hay menos de cinco repartidores: en ellas aparecerán todos.
]

== Consulta 3. Análisis de saturación y ocupación en Centros de Distribución
Calcular el porcentaje de ocupación volumétrica actual de cada Centro de Distribución. La consulta debe comparar el volumen sumado ($m^3$) de todos los paquetes que se encuentren físicamente en el almacén (en estados `En Almacén Origen` o `En Centro Intermedio`) frente a la capacidad volumétrica máxima catalogada de dicho centro, ordenando de mayor a menor porcentaje de uso.

#caja-pista[
  - Un bulto está en un almacén si su *estado actual* es `'En Almacén Origen'` o `'En Centro Intermedio'`; el centro es el de esa transición.
  - Las dimensiones de los bultos están en centímetros y la capacidad del centro (`centro_distribucion.volumen`) en metros cúbicos.
  - Deben aparecer todos los centros, también los que estén vacíos.
  - Las capacidades de los centros son realistas, así que los porcentajes de ocupación serán muy pequeños. Mostradlos con suficientes decimales.
]

== Consulta 4. Auditoría de incumplimiento de servicio y paquetes paralizados
Identificar todos los paquetes activos (aún no en `Entregado` ni `Devuelto a Origen`) que lleven más de 48 horas continuas sin registrar ningún nuevo cambio de estado en la tabla de seguimiento. Mostrar: código del paquete, razón social/nombre del emisor, teléfono de destino, horas de paralización acumuladas, última ubicación registrada y nombre del empleado que realizó el último escaneo.

#caja-pista[
  - El modelo no guarda el teléfono del destinatario. En su lugar, mostrad la dirección de destino y el teléfono del cliente emisor.
  - El nombre del emisor es la razón social si es una empresa o el nombre y los apellidos si es un particular.
  - Mostrad también el estado actual y la fecha del último movimiento.
  - Ordenad de mayor a menor tiempo de paralización.
]

== Consulta 5. Simulación de liquidación y facturación agrupada mensual
Para cada empresa cliente registrada, calcular la propuesta de liquidación del mes cerrado anterior. La salida debe contener: CIF, Razón Social, total de paquetes entregados facturables, importe bruto total, tramo porcentual de descuento aplicado (0%, 10% o 15%), importe descontado y base neta final a cobrar.

#caja-pista[
  - Como la factura se asigna al envío completo, un bulto es facturable si su envío *aún no tiene factura* y *alguno de los bultos del envío* se entregó en septiembre de 2026. En ese caso se facturan todos los bultos del envío.
  - El importe de cada bulto se calcula con la fórmula de tarifas (@sec-tarifa).
  - Descuento: 15 % si la empresa tiene más de 200 bultos facturables, 10 % si tiene más de 50 y 0 % en otro caso. Se aplica sobre el importe bruto total y se redondea a dos decimales.
  - Deben aparecer todas las empresas, también las que no tengan nada que facturar.
]

== Consulta 6. Detección de cuellos de botella en tránsitos interprovinciales
Identificar aquellos pares de centros (Centro Origen #sym.arrow Centro Destino) en los que el tiempo medio de tránsito de los manifiestos de carga durante el último trimestre haya excedido en más de un 25% la media de velocidad global de la compañía.

#caja-pista[
  - El modelo no guarda distancias, así que no se puede calcular una velocidad: la comparación se hace por *tiempos*. Un par de centros es un cuello de botella si su tiempo medio de tránsito supera en más de un 25 % el tiempo medio de tránsito de todos los manifiestos del trimestre.
  - El tiempo de tránsito de un bulto va desde su transición `'En Tránsito'` hasta su transición `'En Centro Intermedio'`. El tiempo de un manifiesto es la media de los tiempos de sus bultos.
  - Se consideran los manifiestos con fecha de julio a septiembre de 2026.
  - Salida: centro de origen, centro de destino, número de manifiestos, horas medias de tránsito del par, horas medias globales y porcentaje de exceso.
  - Pensad qué limitación tiene comparar por tiempos en lugar de por velocidades: ¿qué rutas aparecerán aunque no tengan ningún problema?
]

== Consulta 7. Rentabilidad comparativa de flota (propia vs. arrendada)
Calcular el coste operativo estimado por paquete entregado diferenciando los envíos realizados en vehículos propios (considerando una cuota de amortización estandarizada por kilómetro/día de ruta) frente a los vehículos en régimen de alquiler (computando la suma íntegra de los costes diarios de alquiler durante los días de ruta asignados).

#caja-pista[
  - Los días de ruta de un vehículo son los días distintos en los que tiene alguna transición `'En Reparto'`.
  - Como no se guardan kilómetros, se supone que cada vehículo recorre 140 km por día de ruta, con una amortización de 0,12 € por km. Coste de un vehículo propio: días de ruta #sym.dot 140 #sym.dot 0,12 €. Coste de un vehículo alquilado: días de ruta #sym.dot `precio_dia`.
  - Los paquetes entregados de un vehículo son los bultos distintos repartidos en él (`'En Reparto'`) que han llegado a `'Entregado'`.
  - Periodo: todo el histórico hasta `@ahora`.
  - Salida, una fila por tipo de flota: número de vehículos, días de ruta, coste total, paquetes entregados y coste por paquete.
]

== Consulta 8. Ratio de éxito de entrega por canal
Obtener una comparativa porcentual del ratio de éxito de entrega en el primer intento entre los envíos asignados a Domicilio Particular frente a los destinados a Taquillas Inteligentes de la red.

#caja-pista[
  - El canal de un bulto lo determina su destino (`bulto.direccion_destino`): punto de recogida o domicilio particular.
  - Solo se tienen en cuenta los bultos que han salido a reparto y tienen ya un resultado (entrega, incidencia o devolución).
  - Un bulto tiene éxito en el primer intento si se ha entregado, no tiene incidencias y ha salido a reparto una sola vez.
]

== Consulta 9. Rotación de taquillas inteligentes
Para todas las taquillas de la red, calcular el tiempo medio (en horas) que tarda un destinatario en retirar su paquete desde que pasa al estado `Disponible en Taquilla` hasta que se confirma `Entregado`.

#caja-pista[
  - Como los bultos no se relacionan con casilleros concretos, la consulta se hace *por punto de recogida*.
  - Deben aparecer todos los puntos de recogida, con su zona y el número de paquetes recogidos, también los que no tengan ninguna recogida.
]

== Consulta 10. Saturación de taquillas inteligentes
Listar aquellas taquillas concretas que actualmente tengan casilleros bloqueados con paquetes que superen las 72 horas sin ser recogidos.

#caja-pista[
  - Igual que en la consulta anterior, se trabaja por punto de recogida: los paquetes cuyo estado actual sea `'Disponible en Taquilla'` desde hace más de 72 horas.
  - Para cada punto, mostrad el número total de casilleros, el número de paquetes en esa situación, las horas del paquete más antiguo y la lista de códigos de seguimiento (`GROUP_CONCAT`).
]

== Consulta 11. Detección de inconsistencias e infracciones de trazabilidad
Localizar y listar aquellos paquetes que presenten saltos antirreglamentarios en su historial de trazabilidad:

+ Paquetes registrados en estado `Entregado` sin haber pasado de forma obligatoria por un estado intermedio `En Reparto` o `Disponible en Taquilla`.
+ Registros en los que la marca temporal de un cambio de estado posterior sea cronológicamente anterior a la marca temporal de su estado antecesor (incoherencia horaria de escaneo).

#caja-pista[
  - Se pueden resolver como dos consultas separadas (11a y 11b).
  - En la 11a, mostrad también la fecha de entrega y el estado inmediatamente anterior a la entrega.
  - En la 11b, el orden "lógico" de los estados es el de la máquina de estados: `Registrado` (1), `En Almacén Origen` (2), `En Tránsito` (3), `En Centro Intermedio` (4), `En Reparto` (5), `Disponible en Taquilla` (6) y `Entregado` o `Devuelto a Origen` (7). `Incidencia` puede darse en cualquier punto y se excluye del análisis. Hay una incoherencia cuando, ordenando las transiciones de un bulto por fecha, un estado aparece detrás de otro de orden lógico mayor.
  - Revisad si alguno de los paquetes de la 11b aparece también en otras consultas (por ejemplo, en la 4). ¿Por qué ocurre?
]

#showybox(
  title-style: (
    weight: 1200,
    color: white,
    sep-thickness: 0pt,
    align: left
  ),
  frame: (
    title-color: red.lighten(20%),
    border-color: red.darken(40%),
    thickness: (left: 2pt),
    radius: 0pt
  ),
  title: [#fa-triangle-exclamation() Nota importante],
  [
    El resto del documento se irá liberando progresivamente a lo largo del semestre, conforme se vayan desarrollando los hitos de la práctica. El profesorado proporcionará las instrucciones y materiales complementarios necesarios para cada fase de trabajo.
  ]
)
