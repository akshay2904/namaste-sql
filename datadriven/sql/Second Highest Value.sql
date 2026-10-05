-- ======================================================================
-- Second Highest Value
-- ======================================================================
-- Difficulty : Easy
-- Company    : Calix
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/second_highest_value
-- ======================================================================

/*
Find the second-highest metric value across the entire employee metrics table. Multiple employees might share the top spot; the second-highest is the next unique value below them. Return a single number.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['metric_value']:
  [98.6]
*/


-- Write your SQL solution below:

SELECT metric_value
FROM (SELECT DISTINCT metric_value, DENSE_RANK() OVER (ORDER BY metric_value DESC) AS rnk FROM employee_metrics) ranked
WHERE rnk = 2
