-- ======================================================================
-- Weekly Transaction Volume
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/weekly_transaction_volume
-- ======================================================================

/*
For Q1 2026, calculate total transaction quantity per week (starting Sunday). Show the week start date and total quantity.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['week_start', 'total_quantity']:
  ['2025-12-28', 6]
  ['2026-01-04', 3]
  ['2026-01-11', 8]
  ['2026-01-18', 4]
  ['2026-01-25', 6]
*/


-- Write your SQL solution below:

SELECT date(transaction_date, '-' || strftime('%w', transaction_date) || ' days') AS week_start,
       SUM(quantity) AS total_quantity
FROM transactions
WHERE transaction_date >= '2026-01-01' AND transaction_date < '2026-04-01'
GROUP BY week_start
ORDER BY week_start
