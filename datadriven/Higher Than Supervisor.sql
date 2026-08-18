-- ======================================================================
-- Higher Than Supervisor
-- ======================================================================
-- Difficulty : Easy
-- Company    : Chewy
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/higher_than_supervisor
-- ======================================================================

/*
Surface employees whose salary is higher than their direct manager's. Pull the employee's name and salary alongside their manager's name and salary, excluding anyone who reports to no one.

Table: employees(employee_id, emp_name, salary, manager_id)

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Expected output ['employee', 'emp_salary', 'manager', 'mgr_salary']:
  ['Nia Alexander', 145790, 'Alice Chen', 55731]
  ['Nia Alexander', 145790, 'Alice Chen', 55731]
  ['Uri Ford', 145176, 'Grace Lee', 55117]
  ['Uri Ford', 145176, 'Grace Lee', 55117]
  ['Via Hamilton', 150907, 'Hank Brown', 60848]
*/


-- Write your SQL solution below:

SELECT e.emp_name AS employee, e.salary AS emp_salary, m.emp_name AS manager, m.salary AS mgr_salary FROM employees e JOIN employees m ON e.manager_id = m.employee_id WHERE e.salary > m.salary ORDER BY e.salary - m.salary DESC, e.emp_name
