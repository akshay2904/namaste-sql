-- ======================================================================
-- Split Metric Sums
-- ======================================================================
-- Difficulty : Medium
-- Company    : Tesla
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/split_metric_sums
-- ======================================================================

/*
Compute two separate sums from employee metrics: one for metric IDs below 5 and another for metric IDs above 5. Show each sum as its own row with a label distinguishing the two groups.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['label', 'total']:
  ['above_5', 9224.4]
*/


-- Write your SQL solution below:

SELECT
  CASE WHEN metric_id < 5 THEN 'below_5' ELSE 'above_5' END AS label,
  CAST(SUM(metric_value) AS DOUBLE) AS total
FROM employee_metrics
WHERE metric_id != 5
GROUP BY label
