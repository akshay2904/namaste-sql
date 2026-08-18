-- ======================================================================
-- Where the Year Leans
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/senior_to_junior_ratio
-- ======================================================================

/*
A people-analytics team logs one reading per department metric each quarter, and leadership wants to see whether a department's reporting leans toward the first half of the fiscal year (quarters Q1 and Q2) or the second half (quarters Q3 and Q4). For each department, show the first-half reading count, the second-half reading count, and the ratio of the two.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'first_half_count', 'second_half_count', 'half_year_ratio']:
  ['Data', 10, 10, 1]
  ['Design', 10, 10, 1]
  ['Engineering', 10, 10, 1]
  ['Finance', 10, 10, 1]
  ['HR', 10, 10, 1]
*/


-- Write your SQL solution below:

SELECT department,
       SUM(CASE WHEN fiscal_quarter IN ('Q1','Q2') THEN 1 ELSE 0 END) AS first_half_count,
       SUM(CASE WHEN fiscal_quarter IN ('Q3','Q4') THEN 1 ELSE 0 END) AS second_half_count,
       CAST(SUM(CASE WHEN fiscal_quarter IN ('Q1','Q2') THEN 1 ELSE 0 END) AS REAL) / MAX(SUM(CASE WHEN fiscal_quarter IN ('Q3','Q4') THEN 1 ELSE 0 END), 1) AS half_year_ratio
FROM employee_metrics
GROUP BY department
ORDER BY department
