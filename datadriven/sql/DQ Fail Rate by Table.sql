-- ======================================================================
-- DQ Fail Rate by Table
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/dq_fail_rate_by_table
-- ======================================================================

/*
The data engineering team needs to see which tables have the worst data quality among those with a recorded severity. Show the average fail percentage per table, from the cleanest to the dirtiest.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['tbl_name', 'avg_fail_pct']:
  ['orders', 1.0714285714285714]
  ['sessions', 20]
  ['transactions', 35]
  ['users', 50]
  ['products', 61.666666666666664]
*/


-- Write your SQL solution below:

SELECT tbl_name, AVG(fail_pct) AS avg_fail_pct
FROM dq_checks
WHERE severity IS NOT NULL
GROUP BY tbl_name
ORDER BY avg_fail_pct ASC
