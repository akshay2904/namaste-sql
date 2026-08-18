-- ======================================================================
-- Top Metric Values
-- ======================================================================
-- Difficulty : Easy
-- Company    : Siemens
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_metric_values
-- ======================================================================

/*
Surface the five highest unique metric values from employee metrics. If two entries share the same value, count that as one.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['metric_value']:
  [99.3]
  [98.6]
  [97.1]
  [96.4]
  [94.9]
*/


-- Write your SQL solution below:

SELECT DISTINCT metric_value
FROM employee_metrics
ORDER BY metric_value DESC
LIMIT 5
