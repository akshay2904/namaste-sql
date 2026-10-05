-- ======================================================================
-- Department Snapshot
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/department_snapshot
-- ======================================================================

/*
The HR analytics team is building a department performance summary for the all-hands. For each department, show the lowest recorded metric, the highest, the average, and the spread between the two extremes. Rows with a missing metric has no value on file should be left out of all calculations. Only include departments that have contributed more than five valid readings ,  a smaller sample isn't reliable enough to surface. Order results from the widest performance spread to the narrowest.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'min_metric', 'max_metric', 'avg_metric', 'spread']:
  ['Sales', 2.2, 94.2, 45.53333333333333, 92]
  ['Product', 7.3, 99.3, 55.8, 92]
  ['Marketing', 5.9, 94.9, 50.4, 89]
  ['Legal', 8.1, 97.1, 49.6, 89]
  ['Finance', 8.8, 89.8, 50.675, 81]
*/


-- Write your SQL solution below:

SELECT
    department,
    MIN(metric_value) AS min_metric,
    MAX(metric_value) AS max_metric,
    AVG(metric_value) AS avg_metric,
    MAX(metric_value) - MIN(metric_value) AS spread
FROM employee_metrics
WHERE metric_value IS NOT NULL
GROUP BY department
HAVING COUNT(*) > 5
ORDER BY spread DESC
