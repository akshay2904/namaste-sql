-- ======================================================================
-- The Undone
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/data_quality
-- ======================================================================

/*
A reliability review is auditing the databases where migrations have been rolled back. For each of those databases, report its total migration count and how many of those migrations were rolled back, most rollbacks first.

Table: migrations(migr_id, version, status, applied, rollback, dur_ms, author, db_name)

Sample data - migrations ['migr_id', 'version', 'status', 'applied', 'rollback', 'dur_ms', 'author', 'db_name']:
  [123, '002_add_users', 'pending', '2026-02-02 01:00:00', 'DROP TABLE IF EXISTS tbl_1', 41, 'bob', 'staging_main']
  [146, '003_add_orders', 'failed', '2026-03-03 02:00:00', 'DROP TABLE IF EXISTS tbl_2', 72, 'charlie', 'analytics']
  [169, '004_indexes', 'rolled_back', '2026-04-04 03:00:00', 'DROP TABLE IF EXISTS tbl_3', 103, 'dana', 'reporting']
  [192, '005_add_products', 'Applied', '2026-05-05 04:00:00', 'DROP TABLE IF EXISTS tbl_4', 134, 'migration-bot', 'archive']
  [215, '006_add_sessions', 'PENDING', None, 'DROP TABLE IF EXISTS tbl_5', None, 'Alice', 'prod_main']

Expected output ['db_name', 'total_migrations', 'total_rollbacks']:
  ['archive', 40, 8]
  ['reporting', 40, 8]
  ['analytics', 40, 6]
  ['prod_main', 40, 6]
  ['staging_main', 40, 6]
*/


-- Write your SQL solution below:

SELECT
    db_name,
    COUNT(*) AS total_migrations,
    SUM(CASE WHEN LOWER(status) = 'rolled_back' THEN 1 ELSE 0 END) AS total_rollbacks
FROM migrations
GROUP BY db_name
HAVING SUM(CASE WHEN LOWER(status) = 'rolled_back' THEN 1 ELSE 0 END) > 0
ORDER BY total_rollbacks DESC, db_name
