-- ======================================================================
-- Daily Net Revenue
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/daily_net_revenue
-- ======================================================================

/*
Product 1001 needs a daily revenue reconciliation between January 1 and April 30, 2025. Positive transaction amounts are purchases and negative values are refunds. Include all qualifying purchases in that date range, plus any refunds for the same product regardless of date.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['transaction_date', 'net_revenue']:
  ['2026-02-02', 23.46]
*/


-- Write your SQL solution below:

WITH relevant AS (
    SELECT transaction_date, total_amount
    FROM transactions
    WHERE product_id = 1001
      AND total_amount > 0
      AND transaction_date >= '2026-01-01'
      AND transaction_date <= '2026-04-30'
    UNION ALL
    SELECT transaction_date, total_amount
    FROM transactions
    WHERE product_id = 1001
      AND total_amount < 0
)
SELECT transaction_date, SUM(total_amount) AS net_revenue
FROM relevant
GROUP BY transaction_date
ORDER BY transaction_date
