-- ======================================================================
-- Tables With Many DQ Failures
-- ======================================================================
-- Difficulty : Medium
-- Company    : BuzzFeed
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/tables_with_many_dq_failures
-- ======================================================================

/*
Our data quality checks table logs pass/fail results per table. Find tables with three or more failed checks, count their total failures, and rank sorted from most failures to least.

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

SELECT dc.tbl_name, COUNT(*) AS fail_count
FROM dq_checks dc
WHERE dc.passed = 0
GROUP BY dc.tbl_name
HAVING COUNT(*) >= 3
ORDER BY fail_count DESC
