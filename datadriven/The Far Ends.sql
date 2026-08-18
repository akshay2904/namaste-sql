-- ======================================================================
-- The Far Ends
-- ======================================================================
-- Difficulty : Easy
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/extreme_headcount_departments
-- ======================================================================

/*
We're auditing the workforce metrics table for headcount readings at the extremes, ignoring the typical middle. Return every field for the rows whose value is 30 or below or 60 or above, highest value first.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [1740, 'Engineering', 'headcount', 92, 'Q1', 2025]
  [10004240, 'Engineering', 'headcount', 92, 'Q1', 2025]
  [510, 'Engineering', 'headcount', 73, 'Q3', 2025]
  [10004210, 'Engineering', 'headcount', 73, 'Q3', 2025]
  [4200, 'Engineering', 'headcount', 30, 'Q1', 2025]
*/


-- Write your SQL solution below:

SELECT *
FROM employee_metrics
WHERE metric_name = 'headcount'
  AND (metric_value <= 30 OR metric_value >= 60)
ORDER BY metric_value DESC, metric_id
