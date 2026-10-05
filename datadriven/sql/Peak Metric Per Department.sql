-- ======================================================================
-- Peak Metric Per Department
-- ======================================================================
-- Difficulty : Easy
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_metric_per_department
-- ======================================================================

/*
HR is spotting which departments have top-performing individuals by looking at each department's peak metric value, sorted from highest peak to lowest.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'peak_value']:
  ['Product', 99.3]
  ['Design', 98.6]
  ['Legal', 97.1]
  ['Operations', 96.4]
  ['Marketing', 94.9]
*/


-- Write your SQL solution below:

SELECT department, MAX(metric_value) AS peak_value
FROM employee_metrics
GROUP BY department
ORDER BY peak_value DESC
