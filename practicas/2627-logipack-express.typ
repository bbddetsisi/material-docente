#import "@preview/ilm:2.1.1": *
#import "@preview/ccicons:1.0.1": *
#import "@preview/showybox:2.0.4": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/fontawesome:0.6.2": fa-triangle-exclamation, fa-file-pen
#show: codly-init.with()
// #show raw.where(lang: "text"): it => { text(font: "DejaVu Sans Mono", it.text) }

#codly(
  languages: (
    java: (name: "Java", icon: text(font: "Font Awesome 7 Brands", size: 1em, "\u{f4e4} "), color: rgb("#007AFF")),
    text: (name: "Texto", icon: text(font: "Font Awesome 7 Free", size: 1em, "\u{f0f6} "), color: rgb("#000000")),
    sql: (name: "SQL", icon: text(font: "Font Awesome 7 Free", size: 1em, "\u{f1c0} "), color: rgb("#000000")),
  )
)

#set text(lang: "es")
#set quote(block: true)

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
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),
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
  - Transformación al Esquema Relacional con indicación explícita de claves primarias (`PK`) y foráneas (`FK`), junto con sus políticas de mantenimiento de integridad referencial (`ON DELETE` / `ON UPDATE`).

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
  title: [#emoji.notepad Notas de la Reunión 3: Facturación, reclamaciones y calidad del servicio],
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
