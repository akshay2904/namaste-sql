-- ======================================================================
-- Metric Range Per Group
-- ======================================================================
-- Difficulty : Easy
-- Company    : JPMorgan Chase
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/metric_range_per_group
-- ======================================================================

/*
HR suspects some departments have much wider performance variance than others. For each department, compute the spread between its highest and lowest metric values, ordered alphabetically by department.

Table: employee_metrics(metric_id, department, metric_value)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'metric_spread']:
  ['Data', 81]
  ['Design', 92]
  ['Engineering', 81]
  ['HR', 92]
  ['Legal', 89]
*/


-- Write your SQL solution below:

SELECT department, MAX(metric_value) - MIN(metric_value) AS metric_spread
FROM employee_metrics
GROUP BY department
ORDER BY department
