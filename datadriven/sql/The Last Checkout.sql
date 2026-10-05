-- ======================================================================
-- The Last Checkout
-- ======================================================================
-- Difficulty : Medium
-- Company    : Walmart
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/last_checkout_product_count
-- ======================================================================

/*
The retention team wants to understand every user's most recent checkout. For each user in `transactions`, find the most recent date they made a purchase and how many purchase rows they had on that date (a user can show up multiple times on the same date if they bought several items). Return the date, the user id, and the count, sorted from oldest last-purchase date to newest.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['transaction_date', 'user_id', 'purchase_count']:
  ['2026-10-02', 1264, 1]
  ['2026-10-10', 391, 1]
  ['2026-10-14', 973, 1]
  ['2026-10-26', 682, 1]
  ['2026-11-03', 1361, 1]
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT user_id,
           transaction_date,
           RANK() OVER (
               PARTITION BY user_id
               ORDER BY transaction_date DESC
           ) AS rnk
    FROM transactions
)
SELECT transaction_date,
       user_id,
       COUNT(*) AS purchase_count
FROM ranked
WHERE rnk = 1
GROUP BY transaction_date, user_id
ORDER BY transaction_date ASC
