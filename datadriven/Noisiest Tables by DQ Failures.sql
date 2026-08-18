-- ======================================================================
-- Noisiest Tables by DQ Failures
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/noisiest_tables_by_dq_failures
-- ======================================================================

/*
We run data quality checks against various tables. For each table, show the count of failed checks (where passed is false) and the highest failure percentage among those checks. Rank sorted from most failures to least, and skip tables with zero failures.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['tbl_name', 'failure_count', 'max_fail_pct']:
  ['users', 6, 55]
  ['transactions', 6, 40]
  ['sessions', 6, 25]
  ['products', 6, 95]
  ['orders', 4, 10]
*/


-- Write your SQL solution below:

SELECT
    tbl_name,
    COUNT(*) AS failure_count,
    MAX(fail_pct) AS max_fail_pct
FROM dq_checks
WHERE passed = 0
GROUP BY tbl_name
ORDER BY failure_count DESC
