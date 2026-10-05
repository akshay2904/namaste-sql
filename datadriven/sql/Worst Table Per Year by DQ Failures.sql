-- ======================================================================
-- Worst Table Per Year by DQ Failures
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/worst_table_per_year_by_dq_failures
-- ======================================================================

/*
For each year, surface the table with the most failed data quality checks and its failure count.

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['year', 'tbl_name', 'fail_count']:
  ['2026', 'users', 6]
*/


-- Write your SQL solution below:

SELECT year, tbl_name, fail_count
FROM (
    SELECT
        STRFTIME('%Y', run_at) AS year,
        tbl_name,
        COUNT(*) AS fail_count,
        ROW_NUMBER() OVER (
            PARTITION BY STRFTIME('%Y', run_at)
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM dq_checks
    WHERE passed = 0
    GROUP BY STRFTIME('%Y', run_at), tbl_name
) ranked
WHERE rn = 1
ORDER BY year
