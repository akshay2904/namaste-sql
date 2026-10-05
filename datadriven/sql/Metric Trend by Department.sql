-- ======================================================================
-- Metric Trend by Department
-- ======================================================================
-- Difficulty : Easy
-- Company    : BearingPoint
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_headcount_by_department
-- ======================================================================

/*
The VP of Engineering wants a quick read on how each department's tracked metric has moved over time. For each department and fiscal_year, compute the average metric value. Return department, fiscal_year, and the average, ordered by department then year.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'fiscal_year', 'avg_metric_value']:
  ['Data', 2024, 44.2]
  ['Data', 2025, 57.70000000000001]
  ['Data', 2026, 30.7]
  ['Design', 2024, 39.93333333333333]
  ['Design', 2025, 79.6]
*/


-- Write your SQL solution below:

SELECT department, fiscal_year, AVG(metric_value) AS avg_metric_value FROM employee_metrics GROUP BY department, fiscal_year ORDER BY department, fiscal_year
