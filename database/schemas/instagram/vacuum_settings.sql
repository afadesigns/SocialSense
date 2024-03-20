-- vacuum_settings.sql

-- Optimize Vacuum Settings
-- Tailor the autovacuum settings to your workload by adjusting parameters like autovacuum_vacuum_scale_factor and autovacuum_analyze_scale_factor to ensure timely cleanup and analysis of your database tables.

-- Example: Setting autovacuum_vacuum_scale_factor
ALTER SYSTEM SET autovacuum_vacuum_scale_factor = 0.05;

-- Example: Setting autovacuum_analyze_scale_factor
ALTER SYSTEM SET autovacuum_analyze_scale_factor = 0.1;

-- Reload PostgreSQL configuration
SELECT pg_reload_conf();
