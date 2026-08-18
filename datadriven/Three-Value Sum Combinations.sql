-- ======================================================================
-- Three-Value Sum Combinations
-- ======================================================================
-- Difficulty : Medium
-- Company    : Lyft
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/three_value_sum_combinations
-- ======================================================================

/*
Find all combinations of 3 different employee metric records whose values sum to exactly 25. Each combination must use three separate records with no reuse. Show the three values in each qualifying combination.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['val1', 'val2', 'val3']:
  [1.5, 8.1, 15.4]
  [1.5, 8.1, 15.4]
  [1.5, 15.4, 8.1]
  [1.5, 8.1, 15.4]
  [8.8, 8.1, 8.1]
*/


-- Write your SQL solution below:

SELECT e1.metric_value AS val1,
       e2.metric_value AS val2,
       e3.metric_value AS val3
FROM employee_metrics e1
CROSS JOIN employee_metrics e2
CROSS JOIN employee_metrics e3
WHERE e1.metric_id < e2.metric_id
  AND e2.metric_id < e3.metric_id
  AND e1.metric_value + e2.metric_value + e3.metric_value = 25
