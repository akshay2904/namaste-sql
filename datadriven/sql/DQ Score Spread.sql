-- ======================================================================
-- DQ Score Spread
-- ======================================================================
-- Difficulty : Medium
-- Company    : Box
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/dq_score_spread
-- ======================================================================

/*
Each table's data quality total is the sum of fail percentages across all its rules. What is the difference between the table with the highest total and the table with the lowest total?

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['dq_spread']:
  [450]
*/


-- Write your SQL solution below:

SELECT MAX(total_fail) - MIN(total_fail) AS dq_spread
FROM (
    SELECT tbl_name, SUM(fail_pct) AS total_fail
    FROM dq_checks
    GROUP BY tbl_name
) t
