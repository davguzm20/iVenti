-- =============================================================================
-- iVenti Database Triggers
--
-- PostgreSQL 18+ triggers and functions for iVenti audit system.
-- Contains: auditar_general() function and audit triggers for all tables.
-- Requires: iventi-schema.sql must be executed first.
-- =============================================================================

-- =============================================================================
-- SEQUENCES
-- =============================================================================

CREATE SEQUENCE IF NOT EXISTS boleta_seq START 1;

-- =============================================================================
-- FUNCTIONS
-- =============================================================================

CREATE OR REPLACE FUNCTION generar_codigo_boleta()
RETURNS VARCHAR(20) AS $$
DECLARE
  next_val INTEGER;
BEGIN
  next_val := nextval('boleta_seq');
  RETURN 'B' || LPAD(next_val::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION auditar_general()
RETURNS TRIGGER AS $$
DECLARE
  _id_usuario INTEGER;
  _registro_id INTEGER;
BEGIN
  BEGIN
    _id_usuario := NULLIF(current_setting('app.id_usuario', true), '')::INTEGER;
  EXCEPTION WHEN OTHERS THEN
    _id_usuario := NULL;
  END;

  IF TG_TABLE_NAME = 'usuarios' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_usuario;
    ELSE _registro_id := NEW.id_usuario; END IF;
  ELSIF TG_TABLE_NAME = 'ventas' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_venta;
    ELSE _registro_id := NEW.id_venta; END IF;
  ELSIF TG_TABLE_NAME = 'productos' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_producto;
    ELSE _registro_id := NEW.id_producto; END IF;
  ELSIF TG_TABLE_NAME = 'lotes' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_lote;
    ELSE _registro_id := NEW.id_lote; END IF;
  ELSIF TG_TABLE_NAME = 'clientes' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_cliente;
    ELSE _registro_id := NEW.id_cliente; END IF;
  ELSIF TG_TABLE_NAME = 'categorias' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_categoria;
    ELSE _registro_id := NEW.id_categoria; END IF;
  ELSIF TG_TABLE_NAME = 'detalle_ventas' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_detalle_venta;
    ELSE _registro_id := NEW.id_detalle_venta; END IF;
  ELSIF TG_TABLE_NAME = 'notificaciones' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_notificacion;
    ELSE _registro_id := NEW.id_notificacion; END IF;
  ELSIF TG_TABLE_NAME = 'recibos' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_recibo;
    ELSE _registro_id := NEW.id_recibo; END IF;
  ELSIF TG_TABLE_NAME = 'configuraciones' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_configuracion;
    ELSE _registro_id := NEW.id_configuracion; END IF;
  ELSIF TG_TABLE_NAME = 'unidades' THEN
    IF TG_OP = 'DELETE' THEN _registro_id := OLD.id_unidad;
    ELSE _registro_id := NEW.id_unidad; END IF;
  ELSE
    _registro_id := 0;
  END IF;

  INSERT INTO auditoria (id_usuario, tabla, registro_id, operacion, fecha_auditoria)
  VALUES (_id_usuario, TG_TABLE_NAME, _registro_id, TG_OP::operacion_auditoria, CURRENT_TIMESTAMP);

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- TRIGGERS
-- =============================================================================

CREATE TRIGGER trg_auditoria_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_clientes AFTER INSERT OR DELETE OR UPDATE ON clientes FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_productos AFTER INSERT OR DELETE OR UPDATE ON productos FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_lotes AFTER INSERT OR DELETE OR UPDATE ON lotes FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_categorias AFTER INSERT OR DELETE OR UPDATE ON categorias FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_ventas AFTER INSERT OR DELETE OR UPDATE ON ventas FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_detalle_ventas AFTER INSERT OR DELETE OR UPDATE ON detalle_ventas FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_recibos AFTER INSERT OR DELETE OR UPDATE ON recibos FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_notificaciones AFTER INSERT OR DELETE OR UPDATE ON notificaciones FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_configuraciones AFTER INSERT OR DELETE OR UPDATE ON configuraciones FOR EACH ROW EXECUTE FUNCTION auditar_general();
CREATE TRIGGER trg_auditoria_unidades AFTER INSERT OR DELETE OR UPDATE ON unidades FOR EACH ROW EXECUTE FUNCTION auditar_general();
