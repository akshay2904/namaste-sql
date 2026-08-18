-- ======================================================================
-- Metric Range by Department
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/metric_count
-- ======================================================================

/*
HR is profiling how each department's performance metric is distributed. For each department, show the average, minimum, and maximum recorded metric value. Order from highest average to lowest.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'avg_value', 'min_value', 'max_value']:
  ['Product', 55.8, 7.3, 99.3]
  ['Design', 55.27, 6.6, 98.6]
  ['Finance', 50.67, 8.8, 89.8]
  ['Marketing', 50.4, 5.9, 94.9]
  ['Legal', 49.6, 8.1, 97.1]
*/


-- Write your SQL solution below:

SELECT department, ROUND(AVG(metric_value),2) AS avg_value, ROUND(MIN(metric_value),2) AS min_value, ROUND(MAX(metric_value),2) AS max_value FROM employee_metrics GROUP BY department ORDER BY avg_value DESC
