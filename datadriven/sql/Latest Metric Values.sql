-- ======================================================================
-- Latest Metric Values
-- ======================================================================
-- Difficulty : Easy
-- Company    : Microsoft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/latest_metric_values
-- ======================================================================

/*
Some rows in the employee metrics table have outdated values for the same department and metric name. Treat the highest metric value as the current one, and keep only that row for each unique department and metric combination. If there are ties, return any one. Results should appear by department ascending.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'metric_name', 'metric_value']:
  ['Data', 'remote_percentage', 84.7]
  ['Design', 'avg_tenure_months', 98.6]
  ['Engineering', 'headcount', 92]
  ['Finance', 'open_positions', 89.8]
  ['HR', 'promotions', 93.5]
*/


-- Write your SQL solution below:

SELECT department, metric_name, MAX(metric_value) AS metric_value
FROM employee_metrics
GROUP BY department, metric_name
ORDER BY department ASC
