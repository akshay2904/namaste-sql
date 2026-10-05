-- ======================================================================
-- The Loudest Signals
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/longest_active_membership_streak
-- ======================================================================

/*
The analytics team is scanning employee_metrics for its standout readings and wants the most extreme ones, with repeated values collapsed to a single entry. Surface the five highest metric values, listed from highest to lowest.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['metric_value']:
  [99.3]
  [98.6]
  [97.1]
  [96.4]
  [94.9]
*/


-- Write your SQL solution below:

SELECT DISTINCT metric_value
FROM employee_metrics
ORDER BY metric_value DESC
LIMIT 5
