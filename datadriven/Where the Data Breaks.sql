-- ======================================================================
-- Where the Data Breaks
-- ======================================================================
-- Difficulty : Medium
-- Company    : Zoox
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/where-the-data-breaks
-- ======================================================================

/*
Our automated data-quality suite writes one row per check it runs, and we need to see where records are breaking. For each table that has failing checks, report how many checks failed and how many of those were critical or high severity, most failures first.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['tbl_name', 'failing_checks', 'high_severity_failures']:
  ['ad_impressions', 6, 4]
  ['events', 6, 6]
  ['products', 6, 6]
  ['sessions', 6, 4]
  ['orders', 4, 4]
*/


-- Write your SQL solution below:

SELECT tbl_name,
       COUNT(*) AS failing_checks,
       SUM(CASE WHEN LOWER(severity) IN ('high', 'critical') THEN 1 ELSE 0 END) AS high_severity_failures
FROM dq_checks
WHERE passed = 0
GROUP BY tbl_name
ORDER BY failing_checks DESC, tbl_name
