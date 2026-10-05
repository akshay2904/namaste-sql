-- ======================================================================
-- Largest Group
-- ======================================================================
-- Difficulty : Easy
-- Company    : _tombstone_3903
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/largest_group
-- ======================================================================

/*
Which department has the most employees? If two departments are tied, include both. Return the department name and employee count.

Table: employees(employee_id, department)

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Expected output ['department', 'emp_count']:
  ['Data', 20]
  ['Design', 20]
  ['Engineering', 20]
  ['Finance', 20]
  ['HR', 20]
*/


-- Write your SQL solution below:

SELECT department,
       COUNT(*) AS emp_count
FROM employees
GROUP BY department
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM employees
        GROUP BY department
    )
)
