-- ======================================================================
-- Low Severity DQ Checks
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/low_severity_dq_checks
-- ======================================================================

/*
The data engineering team is auditing whether low-severity checks are still worth running. Pull all fields for every data quality check classified as 'low' severity.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [379, 'products', 'amount', 'unique', 1, None, '2026-10-10 09:00:00', 'low']
  [565, 'users', 'email', 'UNIQUE', 0, 45, '2026-04-16 15:00:00', 'low']
  [751, 'orders', 'user_id', 'freshness', 1, 0, '2026-10-22 21:00:00', 'low']
  [937, 'ad_impressions', 'region', 'format', 1, None, '2026-04-28 03:00:00', 'low']
*/


-- Write your SQL solution below:

SELECT check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity
FROM dq_checks
WHERE severity = 'low'
