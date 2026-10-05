-- ======================================================================
-- Max Value Per Location
-- ======================================================================
-- Difficulty : Easy
-- Company    : _tombstone_2216
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/max_value_per_location
-- ======================================================================

/*
HR wants to see the peak performance metric within each department. Show each department alongside its highest recorded metric value.

Table: employee_metrics(metric_id, department, metric_value)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'max_value']:
  ['Product', 99.3]
  ['Design', 98.6]
  ['Legal', 97.1]
  ['Operations', 96.4]
  ['Marketing', 94.9]
*/


-- Write your SQL solution below:

SELECT department, MAX(metric_value) AS max_value
FROM employee_metrics
GROUP BY department
ORDER BY max_value DESC
