-- =============================================================================
-- iVenti Database Users
--
-- PostgreSQL 18+ users and roles for iVenti system.
-- Creates: base roles, then actual login users.
-- IMPORTANT: Replace passwords before execution.
-- =============================================================================

-- =============================================================================
-- BASE ROLES
-- =============================================================================

-- Database owner role
CREATE ROLE iventi_admin_role NOLOGIN;

-- Application role  
CREATE ROLE iventi_app_role NOLOGIN;

-- Audit role (read-only)
CREATE ROLE iventi_auditor_role NOLOGIN;

-- =============================================================================
-- ACTUAL LOGIN USERS
-- =============================================================================

-- Admin user
CREATE ROLE iventi_admin_user WITH
  LOGIN
  PASSWORD 'CHANGE_THIS_ADMIN_PASSWORD'
  CREATEDB
  CREATEROLE;

-- App user
CREATE ROLE iventi_app_user WITH
  LOGIN
  PASSWORD 'CHANGE_THIS_APP_PASSWORD';

-- Auditor user
CREATE ROLE iventi_auditor_user WITH
  LOGIN
  PASSWORD 'CHANGE_THIS_AUDITOR_PASSWORD';

-- =============================================================================
-- GRANT ROLE MEMBERSHIP
-- =============================================================================

GRANT iventi_admin_role TO iventi_admin_user;
GRANT iventi_app_role TO iventi_app_user;
GRANT iventi_auditor_role TO iventi_auditor_user;

-- =============================================================================
-- PERMISSIONS
-- =============================================================================

-- DB owner gets full access
GRANT ALL ON DATABASE TO iventi_admin_role;
GRANT ALL ON SCHEMA public TO iventi_admin_role;

-- App user gets CRUD on all tables
GRANT USAGE ON SCHEMA public TO iventi_app_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO iventi_app_role;
GRANT EXECUTE ON FUNCTION auditar_general() TO iventi_app_role;

-- Auditor gets read-only
GRANT USAGE ON SCHEMA public TO iventi_auditor_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO iventi_auditor_role;
