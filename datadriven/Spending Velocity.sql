-- ======================================================================
-- Spending Velocity
-- ======================================================================
-- Difficulty : Medium
-- Company    : Goldman Sachs
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/rolling_weekly_total
-- ======================================================================

/*
A fraud model watches each customer's spending pace, so for every transaction we need a trailing total across that customer's seven most recent purchases up to and including it. Walk each customer's transactions from earliest to latest and return user_id, transaction_date, total_amount, and that trailing total.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'transaction_date', 'total_amount', 'rolling_sum']:
  [100, '2026-01-05', 818.19, 818.19]
  [100, '2026-03-16', 212.04, 1030.23]
  [100, '2026-03-20', 1020.24, 2050.4700000000003]
  [100, '2026-04-16', 212.04, 2262.51]
  [100, '2026-04-20', 1020.24, 3282.75]
*/


-- Write your SQL solution below:

SELECT user_id, transaction_date, total_amount, SUM(total_amount) OVER (PARTITION BY user_id ORDER BY transaction_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_sum
FROM transactions
ORDER BY user_id, transaction_date
