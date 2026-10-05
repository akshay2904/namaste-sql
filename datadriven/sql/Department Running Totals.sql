-- ======================================================================
-- Department Running Totals
-- ======================================================================
-- Difficulty : Medium
-- Company    : Goldman Sachs
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/department_running_totals
-- ======================================================================

/*
Ahead of the annual budget cycle, the CFO wants to see how each department's metric values accumulate quarter over quarter. Return every metric record with an additional column showing the running total of metric_value within each department, sequenced by fiscal year and quarter.

Table: employee_metrics(metric_id, department, metric_name, metric_value, fiscal_quarter, fiscal_year)

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year', 'running_total']:
  [469, 'Data', 'remote_percentage', 65.7, 'Q2', 2024, 138.8]
  [592, 'Design', 'avg_tenure_months', 87.6, 'Q1', 2024, 226.39999999999998]
  [2560, 'Engineering', 'headcount', 38, 'Q1', 2024, 76]
  [1576, 'Finance', 'open_positions', 62.8, 'Q1', 2024, 125.6]
  [1945, 'HR', 'promotions', 28.5, 'Q2', 2024, 57]
*/


-- Write your SQL solution below:

SELECT
    *,
    SUM(metric_value) OVER (
        PARTITION BY department
        ORDER BY fiscal_year, fiscal_quarter
    ) AS running_total
FROM employee_metrics
ORDER BY department, fiscal_year, fiscal_quarter
