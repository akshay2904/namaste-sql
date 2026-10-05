-- ======================================================================
-- Broken Promises Between Tables
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/failed_constraint_checks_count
-- ======================================================================

/*
The data-quality pipeline runs a battery of validation rules over our warehouse tables, logging each run in dq_checks. A downstream consumer just choked on dangling references, so the on-call DE wants to know how bad the referential-integrity situation is. Count how many data quality checks whose rule is referential integrity actually failed (passed = 0). Note that rule names are not stored consistently, so match the rule case-insensitively. Return a single column fail_count.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['fail_count']:
  [6]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS fail_count
FROM dq_checks
WHERE LOWER(rule) LIKE '%referential%'
  AND passed = 0
