-- ======================================================================
-- Nth Highest Salary Per Department
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/nth_highest_salary_per_department
-- ======================================================================

/*
For each department, find the employee with the third-highest salary. If a department has fewer than 3 employees, exclude it. Return department, employee name, and their salary.

Table: employees(employee_id, emp_name, department, salary)

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Expected output ['department', 'emp_name', 'salary']:
  ['Data', 'Xan Sullivan', 127369]
  ['Data', 'Xan Sullivan', 127369]
  ['Design', 'Wes Barnes', 118363]
  ['Design', 'Wes Barnes', 118363]
  ['Engineering', 'Oak Russell', 116521]
*/


-- Write your SQL solution below:

SELECT department, emp_name, salary
FROM (
    SELECT
        department,
        emp_name,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) ranked
WHERE rnk = 3
