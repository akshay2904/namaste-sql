-- ======================================================================
-- Chain of Command
-- ======================================================================
-- Difficulty : Hard
-- Company    : Visa
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/flatten_org_chart_hierarchy
-- ======================================================================

/*
Every employee's `manager_id` points to their manager's `employee_id`, except the CEO, whose `manager_id` is `NULL`. Return each employee with their depth beneath the CEO and the full chain of names from the CEO down, joined by / like a file path and listed in path order.

Table: employees(employee_id, emp_name, manager_id)

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Expected output ['employee_id', 'emp_name', 'depth', 'path']:
  [1, 'Alice Chen', 0, 'Alice Chen']
  [10000101, 'Alice Chen', 0, 'Alice Chen']
  [30, 'Dan Baker', 1, 'Alice Chen/Dan Baker']
  [10000130, 'Dan Baker', 1, 'Alice Chen/Dan Baker']
  [2, 'Bob Martinez', 0, 'Bob Martinez']
*/


-- Write your SQL solution below:

WITH RECURSIVE tree AS (
    SELECT employee_id, emp_name, manager_id, 0 AS depth, emp_name AS path
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.emp_name, e.manager_id, t.depth + 1, t.path || '/' || e.emp_name
    FROM employees e
    JOIN tree t ON e.manager_id = t.employee_id
)
SELECT employee_id, emp_name, depth, path
FROM tree
ORDER BY path, employee_id
