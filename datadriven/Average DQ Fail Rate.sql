-- ======================================================================
-- Average DQ Fail Rate
-- ======================================================================
-- Difficulty : Easy
-- Company    : Deloitte
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_dq_fail_rate
-- ======================================================================

/*
Several downstream consumers are complaining about bad data but nobody knows which source tables are the worst offenders. Compute the average data quality check fail rate per table, but only surface tables where more than one validation rule has actually been evaluated. Show the table name and its average fail percentage.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['tbl_name', 'avg_fail_pct']:
  ['events', 80]
  ['ad_impressions', 65]
  ['products', 61.666666666666664]
  ['users', 50]
  ['transactions', 35]
*/


-- Write your SQL solution below:

SELECT tbl_name,
       AVG(fail_pct) AS avg_fail_pct
FROM dq_checks
GROUP BY tbl_name
HAVING COUNT(DISTINCT rule) > 1
ORDER BY avg_fail_pct DESC, tbl_name
