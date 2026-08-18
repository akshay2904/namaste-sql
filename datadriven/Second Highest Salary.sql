-- ======================================================================
-- Second Highest Salary
-- ======================================================================
-- Difficulty : Easy
-- Company    : Munich Re
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/second_highest_salary
-- ======================================================================

/*
HR is setting the salary band for a new role and needs the second-highest unique salary on record as a benchmark. If all employees share the same salary, return NULL.

Table: employees(employee_id, emp_name, salary)

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Expected output ['second_highest']:
  [145790]
*/


-- Write your SQL solution below:

SELECT MAX(salary) AS second_highest
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees)
