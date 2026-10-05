-- ======================================================================
-- The Full Picture
-- ======================================================================
-- Difficulty : Easy
-- Company    : DoubleVerify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/joined_employee_details
-- ======================================================================

/*
The people analytics team needs every employee's name alongside their total metric value from employee_metrics, matched on department. Employees whose department has no metrics recorded yet should still appear with a zero, not be dropped from the results.

Table: employees(employee_id, emp_name, department)

Table: employee_metrics(metric_id, department, metric_value)

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Sample data - employee_metrics ['metric_id', 'department', 'metric_name', 'metric_value', 'fiscal_quarter', 'fiscal_year']:
  [141, 'Product', 'attrition_rate', 7.3, 'Q2', 2025]
  [182, 'Design', 'avg_tenure_months', 14.6, 'Q3', 2026]
  [223, 'Marketing', 'satisfaction_score', 21.9, 'Q4', 2024]
  [264, 'Sales', 'training_hours', 29.2, 'Q1', 2025]
  [305, 'HR', 'promotions', 36.5, 'Q2', 2026]

Expected output ['emp_name', 'total_metric_value']:
  ['Alice Chen', 862]
  ['Bob Martinez', 1116]
  ['Carol Wu', 994.8]
  ['David Kim', 1008]
  ['Eve Johnson', 819.6]
*/


-- Write your SQL solution below:

SELECT e.emp_name, COALESCE(SUM(m.metric_value), 0) AS total_metric_value
FROM employees e
LEFT JOIN employee_metrics m ON e.department = m.department
GROUP BY e.employee_id, e.emp_name
