-- =============================================================================
-- iVenti Database Inserts
--
-- PostgreSQL 18+ initial seed data for iVenti system.
-- Contains: default units and categories.
-- Requires: iventi-schema.sql and iventi-triggers.sql must be executed first.
-- NOTE: Admin user must be created manually via INSERT INTO usuarios (...)
-- =============================================================================

-- =============================================================================
-- UNIDADES
-- =============================================================================

INSERT INTO unidades (nombre, abreviatura) VALUES
  ('Unidad', 'unid'),
  ('Kilogramo', 'kg'),
  ('Litro', 'l'),
  ('Gramo', 'g'),
  ('Mililitro', 'ml'),
  ('Metro', 'm'),
  ('Centimetro', 'cm'),
  ('Docena', 'doc');

-- =============================================================================
-- CATEGORIAS
-- =============================================================================

INSERT INTO categorias (nombre) VALUES
  ('General'),
  ('Alimentos'),
  ('Bebidas'),
  ('Limpieza'),
  ('Higiene Personal'),
  ('Hogar'),
  ('Mascotas'),
  ('Electrónica');
