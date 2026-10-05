-- ======================================================================
-- Last Migration Record
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/last_migration_record
-- ======================================================================

/*
We need to verify the latest schema migration applied to the database. Find the most recently applied migration, identified by the largest migration ID. Show all available fields: migration ID, version, status, applied date, rollback info, duration, author, and database name.

Table: migrations(migr_id, version, status, applied, rollback, dur_ms, author, db_name)

Sample data - migrations ['migr_id', 'version', 'status', 'applied', 'rollback', 'dur_ms', 'author', 'db_name']:
  [123, '002_add_users', 'pending', '2026-02-02 01:00:00', 'DROP TABLE IF EXISTS tbl_1', 41, 'bob', 'staging_main']
  [146, '003_add_orders', 'failed', '2026-03-03 02:00:00', 'DROP TABLE IF EXISTS tbl_2', 72, 'charlie', 'analytics']
  [169, '004_indexes', 'rolled_back', '2026-04-04 03:00:00', 'DROP TABLE IF EXISTS tbl_3', 103, 'dana', 'reporting']
  [192, '005_add_products', 'Applied', '2026-05-05 04:00:00', 'DROP TABLE IF EXISTS tbl_4', 134, 'migration-bot', 'archive']
  [215, '006_add_sessions', 'PENDING', None, 'DROP TABLE IF EXISTS tbl_5', None, 'Alice', 'prod_main']

Expected output ['migr_id', 'version', 'status', 'applied', 'rollback', 'dur_ms', 'author', 'db_name']:
  [10002500, '001_init', 'Applied', None, 'DROP TABLE IF EXISTS tbl_100', None, 'migration-bot', 'prod_main']
*/


-- Write your SQL solution below:

SELECT *
FROM migrations
WHERE migr_id = (SELECT MAX(migr_id) FROM migrations);
