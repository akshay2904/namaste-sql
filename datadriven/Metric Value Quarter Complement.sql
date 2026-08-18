-- ======================================================================
-- Metric Value Quarter Complement
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/metric_value_quarter_complement
-- ======================================================================

/*
HR is testing a budget allocation formula where the integer part of a metric value plus the quarter number (extracted from Q1, Q2, etc.) should equal 5. Surface every employee metric entry that satisfies this condition.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [674, 'Sales', 'training_hours', 2.2, 'Q3', 2026]
  [1248, 'Operations', 'diversity_ratio', 4.4, 'Q1', 2025]
  [2355, 'HR', 'promotions', 1.5, 'Q4', 2025]
  [2929, 'Data', 'remote_percentage', 3.7, 'Q2', 2024]
  [10004214, 'Sales', 'training_hours', 2.2, 'Q3', 2026]
*/


-- Write your SQL solution below:

SELECT *
FROM employee_metrics
WHERE CAST(metric_value AS INTEGER) + CAST(SUBSTR(fiscal_quarter, 2) AS INTEGER) = 5
ORDER BY metric_id
