-- ======================================================================
-- Tables With Most DQ Failures
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/tables_with_most_dq_failures
-- ======================================================================

/*
A downstream compliance team needs to know which tables have the most data quality failures. Count failed checks per table and rank them sorted from most failures to least.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['tbl_name', 'fail_count']:
  ['users', 6]
  ['transactions', 6]
  ['sessions', 6]
  ['products', 6]
  ['orders', 4]
*/


-- Write your SQL solution below:

SELECT tbl_name, COUNT(*) AS fail_count
FROM dq_checks
WHERE passed = 0
GROUP BY tbl_name
ORDER BY fail_count DESC
