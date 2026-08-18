-- ======================================================================
-- Above Their Station
-- ======================================================================
-- Difficulty : Medium
-- Company    : Deloitte
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/above-their-station
-- ======================================================================

/*
A workforce analytics team is auditing pay structure and wants to spot people who out-earn the person they report to. List each such employee next to their manager with both salaries, widest pay gap at the top.

Table: employees(employee_id, emp_name, department, salary, manager_id, hire_date, user_id)

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Expected output ['employee_name', 'employee_salary', 'manager_name', 'manager_salary', 'salary_gap']:
  ['Nia Alexander', 145790, 'Alice Chen', 55731, 90059]
  ['Uri Ford', 145176, 'Grace Lee', 55117, 90059]
  ['Via Hamilton', 150907, 'Hank Brown', 60848, 90059]
  ['Nia Alexander', 145790, 'Alice Chen', 55731, 90059]
  ['Uri Ford', 145176, 'Grace Lee', 55117, 90059]
*/


-- Write your SQL solution below:

SELECT e.emp_name AS employee_name,
       e.salary AS employee_salary,
       m.emp_name AS manager_name,
       m.salary AS manager_salary,
       e.salary - m.salary AS salary_gap
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary
ORDER BY salary_gap DESC
