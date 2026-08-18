-- ======================================================================
-- Metric Value Pairs Over Threshold
-- ======================================================================
-- Difficulty : Medium
-- Company    : Delta Air Lines
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/metric_value_pairs_over_threshold
-- ======================================================================

/*
Find all pairs of employee metric values where the first is smaller than the second and their product exceeds 11. Show both values in ascending order.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['metric_value_1', 'metric_value_2']:
  [1.5, 8.1]
  [1.5, 8.1]
  [1.5, 8.1]
  [1.5, 8.1]
  [1.5, 8.8]
*/


-- Write your SQL solution below:

SELECT e1.metric_value AS metric_value_1,
       e2.metric_value AS metric_value_2
FROM employee_metrics e1
CROSS JOIN employee_metrics e2
WHERE e1.metric_value < e2.metric_value
  AND e1.metric_value * e2.metric_value > 11
ORDER BY e1.metric_value ASC, e2.metric_value ASC
