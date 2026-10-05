-- ======================================================================
-- Cumulative Sales Per Customer
-- ======================================================================
-- Difficulty : Medium
-- Company    : Goldman Sachs
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cumulative_sales_per_customer
-- ======================================================================

/*
The finance team wants to track each customer's spending trajectory over time. Show every transaction alongside the customer's cumulative total spend up to and including that row, ordered by transaction date.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'product_id', 'total_amount', 'transaction_date', 'cumulative_sales']:
  [100, 3892, 818.19, '2026-01-05', 818.19]
  [100, 1687, 212.04, '2026-03-16', 1030.23]
  [100, 4627, 1020.24, '2026-03-20', 2050.4700000000003]
  [100, 1687, 212.04, '2026-04-16', 2262.51]
  [100, 4627, 1020.24, '2026-04-20', 3282.75]
*/


-- Write your SQL solution below:

SELECT
    user_id,
    product_id,
    total_amount,
    transaction_date,
    SUM(total_amount) OVER (
        PARTITION BY user_id
        ORDER BY transaction_date, transaction_id
    ) AS cumulative_sales
FROM transactions
ORDER BY user_id, transaction_date, transaction_id
