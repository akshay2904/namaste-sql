-- ======================================================================
-- Metric Volatility Gap
-- ======================================================================
-- Difficulty : Easy
-- Company    : JPMorgan Chase
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/metric_volatility_gap
-- ======================================================================

/*
HR suspects some departments have wild performance swings while others are stable. Show each department's metric value spread (highest minus lowest), with the most volatile departments first.

Table: employee_metrics(metric_id, department, metric_value)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['department', 'volatility']:
  ['Sales', 92]
  ['Product', 92]
  ['Marketing', 89]
  ['Legal', 89]
  ['Finance', 81]
*/


-- Write your SQL solution below:

SELECT department, MAX(metric_value) - MIN(metric_value) AS volatility
FROM employee_metrics
GROUP BY department
ORDER BY volatility DESC
