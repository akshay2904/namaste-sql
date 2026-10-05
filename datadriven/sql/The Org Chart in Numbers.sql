-- ======================================================================
-- The Org Chart in Numbers
-- ======================================================================
-- Difficulty : Hard
-- Company    : Block
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/department_quarterly_pivot
-- ======================================================================

/*
Show employee count broken down by department and fiscal quarter. For each department, create columns Q1 through Q4 showing how many metric entries exist per quarter. If a quarter has no entries, show 0.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'q1', 'q2', 'q3', 'q4']:
  ['Data', 0, 10, 0, 10]
  ['Design', 10, 0, 10, 0]
  ['Engineering', 10, 0, 10, 0]
  ['HR', 0, 10, 0, 10]
  ['Legal', 0, 10, 0, 10]
*/


-- Write your SQL solution below:

SELECT
    department,
    SUM(CASE WHEN fiscal_quarter = 'Q1' THEN 1 ELSE 0 END) AS q1,
    SUM(CASE WHEN fiscal_quarter = 'Q2' THEN 1 ELSE 0 END) AS q2,
    SUM(CASE WHEN fiscal_quarter = 'Q3' THEN 1 ELSE 0 END) AS q3,
    SUM(CASE WHEN fiscal_quarter = 'Q4' THEN 1 ELSE 0 END) AS q4
FROM employee_metrics
GROUP BY department
