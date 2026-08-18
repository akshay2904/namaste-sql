-- ======================================================================
-- Department Spend Gap
-- ======================================================================
-- Difficulty : Easy
-- Company    : Chewy
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/department_spend_gap
-- ======================================================================

/*
What is the absolute difference between the largest single transaction made by anyone in Engineering and the largest single transaction made by anyone in Marketing?

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Table: employees(employee_id, emp_name, department, salary, manager_id, hire_date, user_id)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Sample data - employees ['employee_id', 'emp_name', 'department', 'salary', 'manager_id', 'hire_date', 'user_id']:
  [1, 'Alice Chen', 'Engineering', 55731, None, '2021-02-02', 100]
  [2, 'Bob Martinez', 'Product', 61462, None, '2022-03-03', 197]
  [3, 'Carol Wu', 'Design', 67193, None, '2023-04-04', 294]
  [4, 'David Kim', 'Marketing', 72924, None, '2024-05-05', 391]
  [5, 'Eve Johnson', 'Sales', 78655, None, '2025-06-06', 488]

Expected output ['spend_gap']:
  [40.41000000000008]
*/


-- Write your SQL solution below:

SELECT ABS(
    (SELECT MAX(t.total_amount)
     FROM transactions t
     JOIN employees e ON t.user_id = e.user_id
     WHERE e.department = 'Engineering')
    -
    (SELECT MAX(t.total_amount)
     FROM transactions t
     JOIN employees e ON t.user_id = e.user_id
     WHERE e.department = 'Marketing')
) AS spend_gap
