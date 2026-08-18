-- ======================================================================
-- First Arrivals
-- ======================================================================
-- Difficulty : Medium
-- Company    : JPMorgan Chase
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/new_customers_per_day
-- ======================================================================

/*
For each calendar date, how many customers placed their very first order on that day? A customer's first-order date is the earliest order they have in the table.

Table: transactions(transaction_id, user_id, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['first_date', 'new_customers']:
  ['2022-01-02', 1]
  ['2022-02-03', 1]
  ['2022-03-24', 1]
  ['2023-01-10', 1]
  ['2023-02-03', 1]
*/


-- Write your SQL solution below:

WITH first_purchase AS (
    SELECT user_id, MIN(transaction_date) AS first_date
    FROM transactions
    GROUP BY user_id
)
SELECT first_date, COUNT(*) AS new_customers
FROM first_purchase
GROUP BY first_date
ORDER BY first_date
