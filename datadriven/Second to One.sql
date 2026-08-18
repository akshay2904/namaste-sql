-- ======================================================================
-- Second to One
-- ======================================================================
-- Difficulty : Medium
-- Company    : Cisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/second-to-one-department-salaries
-- ======================================================================

/*
A compensation review is comparing pay bands across departments. For each department, find the second highest salary, counting everyone who shares a pay figure as a single level, and list the departments alphabetically.

Table: employees(employee_id, emp_name, department, salary, manager_id, hire_date)

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Expected output ['department', 'second_highest_salary']:
  ['Data', 130439]
  ['Design', 127983]
  ['Engineering', 119591]
  ['Finance', 128597]
  ['HR', 135556]
*/


-- Write your SQL solution below:

WITH salary_ranks AS (
  SELECT department,
         salary,
         DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
  FROM employees
)
SELECT DISTINCT department,
       salary AS second_highest_salary
FROM salary_ranks
WHERE salary_rank = 2
ORDER BY department
