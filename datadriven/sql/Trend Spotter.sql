-- ======================================================================
-- Trend Spotter
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/trend_spotter
-- ======================================================================

/*
Data science wants to model spending trends per user over time. For every row in transactions, pull that user's previous transaction amount (by transaction_date) onto the same row, leaving the value empty on a user's first transaction. Return the user_id, total_amount, transaction_date, and the previous amount.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'total_amount', 'transaction_date', 'prev_amount']:
  [100, 818.19, '2026-01-05', None]
  [100, 212.04, '2026-03-16', 818.19]
  [100, 1020.24, '2026-03-20', 212.04]
  [100, 212.04, '2026-04-16', 1020.24]
  [100, 1020.24, '2026-04-20', 212.04]
*/


-- Write your SQL solution below:

SELECT
    user_id,
    total_amount,
    transaction_date,
    LAG(total_amount) OVER (
        PARTITION BY user_id
        ORDER BY transaction_date
    ) AS prev_amount
FROM transactions
