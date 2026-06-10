-- =============================================================================
-- iVenti Database Users - Permissions Only
--
-- PostgreSQL 18+ permissions for iVenti system.
-- NOTE: Roles must be created in Neon Console before running this script.
-- This script only grants permissions at schema and table level.
-- =============================================================================

-- =============================================================================
-- ASSUMES ROLES ALREADY EXIST (created via Neon Console)
-- =============================================================================
-- iventi_admin_user  - Admin role with full access
-- iventi_app_user    - Application role with CRUD access
-- iventi_audit_user  - Audit role with read-only access

-- =============================================================================
-- PERMISSIONS
-- =============================================================================

-- Admin: full access to public schema
GRANT ALL ON SCHEMA public TO iventi_admin_user;

-- App user: CRUD on all tables
GRANT USAGE ON SCHEMA public TO iventi_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO iventi_app_user;
GRANT EXECUTE ON FUNCTION auditar_general() TO iventi_app_user;

-- Revoke access to auditoria table for app user (audit logs are restricted)
REVOKE ALL ON auditoria FROM iventi_app_user;

-- Audit user: read-only access
GRANT USAGE ON SCHEMA public TO iventi_audit_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO iventi_audit_user;

-- Sequences (for INSERT operations)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO iventi_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO iventi_admin_user;

-- Default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO iventi_app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT USAGE, SELECT ON SEQUENCES TO iventi_app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT SELECT ON TABLES TO iventi_audit_user;
