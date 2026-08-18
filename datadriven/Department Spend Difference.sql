-- ======================================================================
-- Department Spend Difference
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/department_spend_difference
-- ======================================================================

/*
Leadership wants to compare peak metric values between engineering and marketing. Find the highest metric value recorded in each of the two departments, then return the absolute gap between them as a single number.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['absolute_difference']:
  [2.9000000000000057]
*/


-- Write your SQL solution below:

SELECT ABS(
  (SELECT MAX(metric_value) FROM employee_metrics WHERE department = 'Engineering')
  - (SELECT MAX(metric_value) FROM employee_metrics WHERE department = 'Marketing')
) AS absolute_difference
