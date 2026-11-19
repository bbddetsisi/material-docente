-- =====================================================================
-- Logipack Express - Modelo relacional
-- Generado a partir de "Logipack Express.erdplus" (modelo E-R extendido)
-- Dialecto: MySQL 8.0.16+ (probado en MySQL 8.4)
-- =====================================================================

-- ---------------------------------------------------------------------
-- Borrado previo (orden inverso de dependencias)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS transicion;
DROP TABLE IF EXISTS manifiesto_bulto;
DROP TABLE IF EXISTS manifiesto;
DROP TABLE IF EXISTS reclamacion;
DROP TABLE IF EXISTS bulto;
DROP TABLE IF EXISTS envio;
DROP TABLE IF EXISTS factura;
DROP TABLE IF EXISTS locker;
DROP TABLE IF EXISTS punto_recogida;
DROP TABLE IF EXISTS domicilio_particular;
DROP TABLE IF EXISTS destino;
DROP TABLE IF EXISTS repartidor;
DROP TABLE IF EXISTS mozo_almacen;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS alquilado;
DROP TABLE IF EXISTS vehiculo;
DROP TABLE IF EXISTS zona;
DROP TABLE IF EXISTS centro_distribucion;
DROP TABLE IF EXISTS empresa;
DROP TABLE IF EXISTS particular;
DROP TABLE IF EXISTS cliente;

-- ---------------------------------------------------------------------
-- CLIENTE (supertipo, especialización total y disjunta)
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
    nif_cif     VARCHAR(15)  NOT NULL,
    telefono    VARCHAR(20),
    email       VARCHAR(100),
    direccion   VARCHAR(200),
    CONSTRAINT pk_cliente PRIMARY KEY (nif_cif)
);

CREATE TABLE particular (
    nif_cif     VARCHAR(15)  NOT NULL,
    nombre      VARCHAR(50)  NOT NULL,
    apellidos   VARCHAR(100) NOT NULL,
    CONSTRAINT pk_particular PRIMARY KEY (nif_cif),
    CONSTRAINT fk_particular_cliente FOREIGN KEY (nif_cif)
        REFERENCES cliente (nif_cif) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE empresa (
    nif_cif       VARCHAR(15)  NOT NULL,
    razon_social  VARCHAR(150) NOT NULL,
    contacto      VARCHAR(100),
    CONSTRAINT pk_empresa PRIMARY KEY (nif_cif),
    CONSTRAINT fk_empresa_cliente FOREIGN KEY (nif_cif)
        REFERENCES cliente (nif_cif) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- CENTRO DE DISTRIBUCIÓN
-- ---------------------------------------------------------------------
CREATE TABLE centro_distribucion (
    codigo      VARCHAR(10)   NOT NULL,
    nombre      VARCHAR(100)  NOT NULL,
    direccion   VARCHAR(200),
    provincia   VARCHAR(50),
    superficie  DECIMAL(10,2),
    volumen     DECIMAL(12,2),
    CONSTRAINT pk_centro_distribucion PRIMARY KEY (codigo)
);

-- ---------------------------------------------------------------------
-- ZONA
-- ---------------------------------------------------------------------
CREATE TABLE zona (
    codigo      VARCHAR(10)  NOT NULL,
    nombre      VARCHAR(100) NOT NULL,
    CONSTRAINT pk_zona PRIMARY KEY (codigo)
);

-- ---------------------------------------------------------------------
-- VEHÍCULO (supertipo, especialización parcial) y ALQUILADO
-- ---------------------------------------------------------------------
CREATE TABLE vehiculo (
    matricula   VARCHAR(10)  NOT NULL,
    marca       VARCHAR(50),
    modelo      VARCHAR(50),
    tipo        VARCHAR(30),
    estado      VARCHAR(30),
    volumen     DECIMAL(8,2),
    mma         DECIMAL(8,2),
    CONSTRAINT pk_vehiculo PRIMARY KEY (matricula)
);

CREATE TABLE alquilado (
    matricula           VARCHAR(10)   NOT NULL,
    precio_dia          DECIMAL(8,2)  NOT NULL,
    fecha_renovacion    DATE,
    CONSTRAINT pk_alquilado PRIMARY KEY (matricula),
    CONSTRAINT fk_alquilado_vehiculo FOREIGN KEY (matricula)
        REFERENCES vehiculo (matricula) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- EMPLEADO (supertipo, especialización total y disjunta)
-- ---------------------------------------------------------------------
CREATE TABLE empleado (
    dni         VARCHAR(9)    NOT NULL,
    nombre      VARCHAR(100)  NOT NULL,
    telefono    VARCHAR(20),
    salario     DECIMAL(10,2),
    CONSTRAINT pk_empleado PRIMARY KEY (dni)
);

-- asignado a: MOZO DE ALMACÉN (0,M) -- CENTRO DE DISTRIBUCIÓN (1,1)
CREATE TABLE mozo_almacen (
    dni             VARCHAR(9)   NOT NULL,
    codigo_centro   VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_mozo_almacen PRIMARY KEY (dni),
    CONSTRAINT fk_mozo_empleado FOREIGN KEY (dni)
        REFERENCES empleado (dni) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mozo_centro FOREIGN KEY (codigo_centro)
        REFERENCES centro_distribucion (codigo) ON UPDATE CASCADE
);

-- asignado zona: REPARTIDOR (0,M) -- ZONA (1,1)
-- conduce:       REPARTIDOR (0,1) -- VEHÍCULO (1,1)  => relación 1:1
CREATE TABLE repartidor (
    dni                 VARCHAR(9)   NOT NULL,
    num_permiso         VARCHAR(20)  NOT NULL,
    fecha_renovacion    DATE,
    codigo_zona         VARCHAR(10)  NOT NULL,
    matricula_vehiculo  VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_repartidor PRIMARY KEY (dni),
    CONSTRAINT uq_repartidor_vehiculo UNIQUE (matricula_vehiculo),
    CONSTRAINT fk_repartidor_empleado FOREIGN KEY (dni)
        REFERENCES empleado (dni) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_repartidor_zona FOREIGN KEY (codigo_zona)
        REFERENCES zona (codigo) ON UPDATE CASCADE,
    CONSTRAINT fk_repartidor_vehiculo FOREIGN KEY (matricula_vehiculo)
        REFERENCES vehiculo (matricula) ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- DESTINO (supertipo, especialización total y disjunta)
-- pertenece a: DESTINO -- ZONA (1,1)
-- ---------------------------------------------------------------------
CREATE TABLE destino (
    direccion     VARCHAR(200) NOT NULL,
    codigo_zona   VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_destino PRIMARY KEY (direccion),
    CONSTRAINT fk_destino_zona FOREIGN KEY (codigo_zona)
        REFERENCES zona (codigo) ON UPDATE CASCADE
);

CREATE TABLE domicilio_particular (
    direccion         VARCHAR(200) NOT NULL,
    notas_entrega     VARCHAR(500),
    CONSTRAINT pk_domicilio_particular PRIMARY KEY (direccion),
    CONSTRAINT fk_domicilio_destino FOREIGN KEY (direccion)
        REFERENCES destino (direccion) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE punto_recogida (
    direccion   VARCHAR(200) NOT NULL,
    CONSTRAINT pk_punto_recogida PRIMARY KEY (direccion),
    CONSTRAINT fk_punto_recogida_destino FOREIGN KEY (direccion)
        REFERENCES destino (direccion) ON DELETE CASCADE ON UPDATE CASCADE
);

-- LOCKER: entidad débil de PUNTO DE RECOGIDA (relación identificadora "está en")
CREATE TABLE locker (
    direccion_punto   VARCHAR(200) NOT NULL,
    numero            INT          NOT NULL,
    pin               VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_locker PRIMARY KEY (direccion_punto, numero),
    CONSTRAINT fk_locker_punto_recogida FOREIGN KEY (direccion_punto)
        REFERENCES punto_recogida (direccion) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- FACTURA: entidad débil de EMPRESA (relación identificadora "de")
-- ---------------------------------------------------------------------
CREATE TABLE factura (
    nif_empresa        VARCHAR(15)  NOT NULL,
    numero             INT          NOT NULL,
    fecha_expedicion   DATE         NOT NULL,
    estado             VARCHAR(30),
    CONSTRAINT pk_factura PRIMARY KEY (nif_empresa, numero),
    CONSTRAINT fk_factura_empresa FOREIGN KEY (nif_empresa)
        REFERENCES empresa (nif_cif) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- ENVÍO
-- crea:    CLIENTE (1,1) -- ENVÍO (0,M)
-- incluye: FACTURA (0,1) -- ENVÍO (1,M)
-- ---------------------------------------------------------------------
CREATE TABLE envio (
    num_pedido            INT          NOT NULL,
    fecha                 DATE         NOT NULL,
    nif_cliente           VARCHAR(15)  NOT NULL,
    factura_nif_empresa   VARCHAR(15),
    factura_numero        INT,
    CONSTRAINT pk_envio PRIMARY KEY (num_pedido),
    CONSTRAINT fk_envio_cliente FOREIGN KEY (nif_cliente)
        REFERENCES cliente (nif_cif) ON UPDATE CASCADE,
    CONSTRAINT fk_envio_factura FOREIGN KEY (factura_nif_empresa, factura_numero)
        REFERENCES factura (nif_empresa, numero) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- BULTO
-- incluye: ENVÍO (1,1) -- BULTO (1,M)
-- hacia:   DESTINO (1,1) -- BULTO (0,M)
-- ---------------------------------------------------------------------
CREATE TABLE bulto (
    codigo_seguimiento   VARCHAR(30)    NOT NULL,
    peso                 DECIMAL(8,2)   NOT NULL,
    ancho                DECIMAL(8,2),
    alto                 DECIMAL(8,2),
    largo                DECIMAL(8,2),
    urgente              BOOLEAN        NOT NULL DEFAULT FALSE,
    fragil               BOOLEAN        NOT NULL DEFAULT FALSE,
    refrigerado          BOOLEAN        NOT NULL DEFAULT FALSE,
    seguro               BOOLEAN        NOT NULL DEFAULT FALSE,
    valor_declarado      DECIMAL(10,2),
    origen               VARCHAR(200),
    num_pedido           INT            NOT NULL,
    direccion_destino    VARCHAR(200)   NOT NULL,
    CONSTRAINT pk_bulto PRIMARY KEY (codigo_seguimiento),
    CONSTRAINT fk_bulto_envio FOREIGN KEY (num_pedido)
        REFERENCES envio (num_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_bulto_destino FOREIGN KEY (direccion_destino)
        REFERENCES destino (direccion) ON UPDATE CASCADE
);

-- reclama: CLIENTE (0,1) -- BULTO (0,M), con atributos importe y abonado.
-- Se implementa como tabla propia (cada bulto tiene como máximo una reclamación)
-- para evitar columnas nulas en BULTO.
CREATE TABLE reclamacion (
    codigo_seguimiento   VARCHAR(30)    NOT NULL,
    nif_cliente          VARCHAR(15)    NOT NULL,
    importe              DECIMAL(10,2)  NOT NULL,
    abonado              BOOLEAN        NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_reclamacion PRIMARY KEY (codigo_seguimiento),
    CONSTRAINT fk_reclamacion_bulto FOREIGN KEY (codigo_seguimiento)
        REFERENCES bulto (codigo_seguimiento) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reclamacion_cliente FOREIGN KEY (nif_cliente)
        REFERENCES cliente (nif_cif) ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- MANIFIESTO
-- origen / destino: CENTRO DE DISTRIBUCIÓN (1,1) -- MANIFIESTO (0,M)
-- cargado en:       VEHÍCULO (1,1) -- MANIFIESTO
-- ---------------------------------------------------------------------
CREATE TABLE manifiesto (
    id                   INT          NOT NULL,
    fecha                DATE         NOT NULL,
    franja               VARCHAR(20)  NOT NULL,
    codigo_centro_origen   VARCHAR(10) NOT NULL,
    codigo_centro_destino  VARCHAR(10) NOT NULL,
    matricula_vehiculo   VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_manifiesto PRIMARY KEY (id),
    CONSTRAINT fk_manifiesto_origen FOREIGN KEY (codigo_centro_origen)
        REFERENCES centro_distribucion (codigo) ON UPDATE CASCADE,
    CONSTRAINT fk_manifiesto_destino FOREIGN KEY (codigo_centro_destino)
        REFERENCES centro_distribucion (codigo) ON UPDATE CASCADE,
    CONSTRAINT fk_manifiesto_vehiculo FOREIGN KEY (matricula_vehiculo)
        REFERENCES vehiculo (matricula) ON UPDATE CASCADE
);

-- incluye: BULTO (1,M) -- MANIFIESTO (0,M)  => relación N:M
CREATE TABLE manifiesto_bulto (
    id_manifiesto        INT          NOT NULL,
    codigo_seguimiento   VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_manifiesto_bulto PRIMARY KEY (id_manifiesto, codigo_seguimiento),
    CONSTRAINT fk_mb_manifiesto FOREIGN KEY (id_manifiesto)
        REFERENCES manifiesto (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mb_bulto FOREIGN KEY (codigo_seguimiento)
        REFERENCES bulto (codigo_seguimiento) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- TRANSICIÓN: entidad débil de BULTO (relación identificadora "cambia")
-- viaja:          VEHÍCULO (0,1)               -- TRANSICIÓN (0,M)
-- llega a:        DESTINO (0,1)                -- TRANSICIÓN (0,M)
-- recibido en:    CENTRO DE DISTRIBUCIÓN (0,1) -- TRANSICIÓN (0,M)
-- gestionado por: EMPLEADO (0,1)               -- TRANSICIÓN (0,M)
--
-- El historial es inmutable (requisito del enunciado): todas sus claves
-- foráneas son RESTRICT. Con CASCADE o SET NULL, borrar o modificar un
-- bulto, vehículo, destino, centro o empleado alteraría el historial, y
-- en MySQL los cambios en cascada no disparan triggers que lo impidan.
-- ---------------------------------------------------------------------
CREATE TABLE transicion (
    codigo_seguimiento   VARCHAR(30)   NOT NULL,
    fecha_hora           DATETIME(3)   NOT NULL,   -- precisión de milisegundos
    estado               VARCHAR(30)   NOT NULL,
    observaciones        VARCHAR(500),
    matricula_vehiculo   VARCHAR(10),
    direccion_destino    VARCHAR(200),
    codigo_centro        VARCHAR(10),
    dni_empleado         VARCHAR(9),
    CONSTRAINT pk_transicion PRIMARY KEY (codigo_seguimiento, fecha_hora),
    CONSTRAINT fk_transicion_bulto FOREIGN KEY (codigo_seguimiento)
        REFERENCES bulto (codigo_seguimiento) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_transicion_vehiculo FOREIGN KEY (matricula_vehiculo)
        REFERENCES vehiculo (matricula) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_transicion_destino FOREIGN KEY (direccion_destino)
        REFERENCES destino (direccion) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_transicion_centro FOREIGN KEY (codigo_centro)
        REFERENCES centro_distribucion (codigo) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_transicion_empleado FOREIGN KEY (dni_empleado)
        REFERENCES empleado (dni) ON DELETE RESTRICT ON UPDATE RESTRICT
);
