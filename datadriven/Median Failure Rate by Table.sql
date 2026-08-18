-- ======================================================================
-- Median Failure Rate by Table
-- ======================================================================
-- Difficulty : Hard
-- Company    : Walmart
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/median_failure_rate_by_table
-- ======================================================================

/*
Compute the median failure percentage for each table being monitored in data quality checks, rounded to the nearest whole number.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['tbl_name', 'median_fail_pct']:
  ['products', 90]
  ['events', 80]
  ['ad_impressions', 65]
  ['users', 50]
  ['transactions', 35]
*/


-- Write your SQL solution below:

SELECT tbl_name,
       ROUND(AVG(fail_pct)) AS median_fail_pct
FROM (
  SELECT tbl_name,
         fail_pct,
         ROW_NUMBER() OVER (PARTITION BY tbl_name ORDER BY fail_pct) AS rn,
         COUNT(*)    OVER (PARTITION BY tbl_name)                    AS cnt
  FROM dq_checks
  WHERE fail_pct IS NOT NULL
)
WHERE rn IN ((cnt + 1) / 2, (cnt + 2) / 2)
GROUP BY tbl_name
ORDER BY median_fail_pct DESC, tbl_name
