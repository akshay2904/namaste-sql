-- ======================================================================
-- Double Take
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/duplicate_dq_check_records
-- ======================================================================

/*
A downstream team flagged that the data quality checks table has rows repeating the same table-and-column combination. Surface every pair that appears more than once along with how many times it shows up, worst offenders first. Include each pair's standing among the offenders and its share of all the duplicated records.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['tbl_name', 'col_name', 'duplicate_count', 'dup_rank', 'pct_of_dups']:
  ['products', 'amount', 30, 1, 15]
  ['users', 'email', 30, 1, 15]
  ['ad_impressions', 'region', 28, 3, 14]
  ['events', 'created_at', 28, 3, 14]
  ['orders', 'user_id', 28, 3, 14]
*/


-- Write your SQL solution below:

WITH pair_counts AS (
    SELECT tbl_name, col_name, COUNT(*) AS duplicate_count
    FROM dq_checks
    GROUP BY tbl_name, col_name
    HAVING COUNT(*) > 1
)
SELECT
    tbl_name,
    col_name,
    duplicate_count,
    RANK() OVER (ORDER BY duplicate_count DESC) AS dup_rank,
    ROUND(100.0 * duplicate_count / SUM(duplicate_count) OVER (), 2) AS pct_of_dups
FROM pair_counts
ORDER BY duplicate_count DESC, tbl_name, col_name
