-- ======================================================================
-- Peak Satisfaction
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_satisfaction
-- ======================================================================

/*
HR is preparing the annual engagement report and wants to see how each department scores on satisfaction. For the satisfaction_score metric, give each department its highest and lowest score along with how many measurements are on file, and list the departments from the highest peak score on down.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'max_score', 'min_score', 'measurement_count']:
  ['Marketing', 94.9, 5.9, 20]
*/


-- Write your SQL solution below:

SELECT
    department,
    MAX(metric_value) AS max_score,
    MIN(metric_value) AS min_score,
    COUNT(*) AS measurement_count
FROM employee_metrics
WHERE metric_name = 'satisfaction_score'
GROUP BY department
ORDER BY max_score DESC
