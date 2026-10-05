-- ======================================================================
-- Top Metric per Department
-- ======================================================================
-- Difficulty : Medium
-- Company    : Asana
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_metric_per_department
-- ======================================================================

/*
For each department, find the entry/entries with the highest metric value (ties share rank 1 and are all shown), showing the department, metric name, value, and its rank within the department.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'metric_name', 'metric_value', 'rnk']:
  ['Data', 'remote_percentage', 84.7, 1]
  ['Design', 'avg_tenure_months', 98.6, 1]
  ['Engineering', 'headcount', 92, 1]
  ['Finance', 'open_positions', 89.8, 1]
  ['HR', 'promotions', 93.5, 1]
*/


-- Write your SQL solution below:

SELECT DISTINCT department, metric_name, metric_value, rnk FROM (SELECT department, metric_name, metric_value, RANK() OVER (PARTITION BY department ORDER BY metric_value DESC) AS rnk FROM employee_metrics) WHERE rnk = 1 ORDER BY department, metric_name
