-- ======================================================================
-- Latest Migration Output per Author
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/latest_migration_per_author
-- ======================================================================

/*
The release manager wants the latest migration each author shipped. For every author in the migrations table, find their most recent migration by applied date, breaking ties in favor of the largest migration ID. Return the author, version, and applied timestamp, sorted alphabetically by author.

Table: migrations(migr_id, version, status, applied, rollback, dur_ms, author, db_name)

Sample data - migrations ['migr_id', 'version', 'status', 'applied', 'rollback', 'dur_ms', 'author', 'db_name']:
  [123, '002_add_users', 'pending', '2026-02-02 01:00:00', 'DROP TABLE IF EXISTS tbl_1', 41, 'bob', 'staging_main']
  [146, '003_add_orders', 'failed', '2026-03-03 02:00:00', 'DROP TABLE IF EXISTS tbl_2', 72, 'charlie', 'analytics']
  [169, '004_indexes', 'rolled_back', '2026-04-04 03:00:00', 'DROP TABLE IF EXISTS tbl_3', 103, 'dana', 'reporting']
  [192, '005_add_products', 'Applied', '2026-05-05 04:00:00', 'DROP TABLE IF EXISTS tbl_4', 134, 'migration-bot', 'archive']
  [215, '006_add_sessions', 'PENDING', None, 'DROP TABLE IF EXISTS tbl_5', None, 'Alice', 'prod_main']

Expected output ['author', 'version', 'applied']:
  ['Alice', '004_indexes', '2026-12-28 11:00:00']
  ['alice', '005_add_products', '2026-07-27 06:00:00']
  ['bob', 'V010_analytics', '2026-08-24 07:00:00']
  ['dana', '002_add_users', '2026-10-26 09:00:00']
  ['migration-bot', '003_add_orders', '2026-11-27 10:00:00']
*/


-- Write your SQL solution below:

SELECT author, version, applied
FROM (
  SELECT author, version, applied, migr_id,
         ROW_NUMBER() OVER (PARTITION BY author ORDER BY applied DESC, migr_id DESC) AS rn
  FROM migrations
) t
WHERE rn = 1
ORDER BY author
