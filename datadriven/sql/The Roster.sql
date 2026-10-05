-- ======================================================================
-- The Roster
-- ======================================================================
-- Difficulty : Easy
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/employees_per_department
-- ======================================================================

/*
We need a headcount breakdown by department, from the biggest teams down to the smallest. When two departments have the same headcount, list them in alphabetical order.

Table: employees(employee_id, emp_name, department, salary, manager_id, hire_date, user_id)

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Expected output ['department', 'employee_count']:
  ['Data', 20]
  ['Design', 20]
  ['Engineering', 20]
  ['Finance', 20]
  ['HR', 20]
*/


-- Write your SQL solution below:

SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department
ORDER BY employee_count DESC, department ASC
