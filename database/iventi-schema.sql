-- =============================================================================
-- iVenti Database Schema
--
-- PostgreSQL 18+ compatible schema for iVenti inventory and sales system.
-- Contains: enums, tables, constraints, foreign keys, and indexes.
-- Execute first: iventi-schema.sql, then iventi-triggers.sql, then iventi-inserts.sql
-- =============================================================================

-- =============================================================================
-- ENUMS
-- =============================================================================

CREATE TYPE tipo_rol AS ENUM ('ADMINISTRADOR', 'OPERATIVO');

CREATE TYPE estado_venta AS ENUM ('PENDIENTE', 'COMPLETADA', 'ANULADA');

CREATE TYPE operacion_auditoria AS ENUM ('INSERT', 'UPDATE', 'DELETE');

CREATE TYPE tipo_notificacion AS ENUM ('STOCK_BAJO', 'STOCK_AGOTADO', 'PROXIMO_VENCER', 'VENCIDO');

-- =============================================================================
-- TABLES
-- =============================================================================

-- Table: auditoria
CREATE TABLE auditoria (
  id_auditoria SERIAL PRIMARY KEY,
  id_usuario INTEGER,
  tabla VARCHAR(50) NOT NULL,
  registro_id INTEGER NOT NULL,
  operacion operacion_auditoria NOT NULL,
  fecha_auditoria TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_origen VARCHAR(45),
  dispositivo VARCHAR(100)
);

-- Table: unidades
CREATE TABLE unidades (
  id_unidad SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  abreviatura VARCHAR(10) NOT NULL,
  es_activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: categorias
CREATE TABLE categorias (
  id_categoria SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  es_activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: clientes
CREATE TABLE clientes (
  id_cliente SERIAL PRIMARY KEY,
  dni VARCHAR(100),
  nombres VARCHAR(100) NOT NULL,
  email VARCHAR(120),
  telefono VARCHAR(20),
  es_deudor BOOLEAN DEFAULT FALSE,
  es_activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: usuarios
CREATE TABLE usuarios (
  id_usuario SERIAL PRIMARY KEY,
  rol tipo_rol DEFAULT 'OPERATIVO' NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(120),
  pin VARCHAR(64),
  es_activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: configuraciones
CREATE TABLE configuraciones (
  id_configuracion SERIAL PRIMARY KEY,
  id_usuario INTEGER NOT NULL,
  clave VARCHAR(100) NOT NULL,
  valor TEXT NOT NULL,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uk_configuraciones_usuario_clave UNIQUE (id_usuario, clave),
  CONSTRAINT fk_configuraciones_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Table: productos
CREATE TABLE productos (
  id_producto SERIAL PRIMARY KEY,
  id_unidad INTEGER NOT NULL,
  codigo VARCHAR(15),
  nombre VARCHAR(150) NOT NULL,
  precio NUMERIC(10, 2) NOT NULL,
  stock_actual INTEGER DEFAULT 0,
  stock_minimo INTEGER DEFAULT 0,
  ruta_imagen VARCHAR(255),
  es_activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT productos_nombre_key UNIQUE (nombre),
  CONSTRAINT fk_productos_unidad FOREIGN KEY (id_unidad) REFERENCES unidades(id_unidad)
);

-- Table: categorias_productos
CREATE TABLE categorias_productos (
  id_categoria INTEGER NOT NULL,
  id_producto INTEGER NOT NULL,
  PRIMARY KEY (id_categoria, id_producto),
  CONSTRAINT fk_categorias_productos_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
  CONSTRAINT fk_categorias_productos_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Table: lotes
CREATE TABLE lotes (
  id_lote SERIAL PRIMARY KEY,
  id_producto INTEGER NOT NULL,
  fecha_compra DATE DEFAULT CURRENT_DATE NOT NULL,
  fecha_vencimiento DATE,
  cantidad_actual INTEGER NOT NULL,
  cantidad_comprada INTEGER NOT NULL,
  cantidad_perdida INTEGER DEFAULT 0,
  precio_compra NUMERIC(10, 2) NOT NULL,
  es_activo BOOLEAN DEFAULT TRUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_lotes_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Table: ventas
CREATE TABLE ventas (
  id_venta SERIAL PRIMARY KEY,
  id_cliente INTEGER NOT NULL,
  id_usuario INTEGER NOT NULL,
  vendido_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  monto_total NUMERIC(10, 2) NOT NULL,
  monto_cancelado NUMERIC(10, 2) DEFAULT 0 NOT NULL,
  estado estado_venta DEFAULT 'PENDIENTE' NOT NULL,
  es_credito BOOLEAN DEFAULT FALSE,
  codigo_boleta VARCHAR(20),
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ventas_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
  CONSTRAINT fk_ventas_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Table: detalle_ventas
CREATE TABLE detalle_ventas (
  id_detalle_venta SERIAL PRIMARY KEY,
  id_venta INTEGER NOT NULL,
  id_lote INTEGER NOT NULL,
  cantidad INTEGER NOT NULL,
  precio_unitario NUMERIC(10, 2) NOT NULL,
  subtotal NUMERIC(10, 2) NOT NULL,
  descuento NUMERIC(10, 2) DEFAULT 0,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_detalle_ventas_lote FOREIGN KEY (id_lote) REFERENCES lotes(id_lote),
  CONSTRAINT fk_detalle_ventas_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
);

-- Table: recibos
CREATE TABLE recibos (
  id_recibo SERIAL PRIMARY KEY,
  id_venta INTEGER NOT NULL,
  id_usuario INTEGER,
  monto_cancelado NUMERIC(10, 2) NOT NULL,
  pagado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_recibos_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
  CONSTRAINT fk_recibos_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Table: notificaciones
CREATE TABLE notificaciones (
  id_notificacion SERIAL PRIMARY KEY,
  id_usuario INTEGER NOT NULL,
  id_producto INTEGER,
  id_lote INTEGER,
  tipo tipo_notificacion NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  contenido TEXT NOT NULL,
  leida BOOLEAN DEFAULT FALSE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_notificaciones_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  CONSTRAINT fk_notificaciones_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  CONSTRAINT fk_notificaciones_lote FOREIGN KEY (id_lote) REFERENCES lotes(id_lote)
);

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_auditoria_usuario ON auditoria (id_usuario);
CREATE INDEX idx_auditoria_registro ON auditoria (registro_id);
CREATE INDEX idx_auditoria_tabla_fecha ON auditoria (tabla, fecha_auditoria);
CREATE INDEX idx_productos_nombre ON productos (nombre);
CREATE INDEX idx_ventas_vendido_en ON ventas (vendido_en DESC);
CREATE INDEX idx_lotes_fecha_vencimiento ON lotes (fecha_vencimiento);

CREATE UNIQUE INDEX clientes_dni_key ON clientes (dni) WHERE dni IS NOT NULL AND dni != '';
CREATE UNIQUE INDEX uk_usuarios_email ON usuarios (email) WHERE email IS NOT NULL AND email != '';
CREATE UNIQUE INDEX productos_codigo_key ON productos (codigo) WHERE codigo IS NOT NULL AND codigo != '';
