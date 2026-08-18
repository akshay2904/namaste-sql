-- ======================================================================
-- Top Percentile Spenders
-- ======================================================================
-- Difficulty : Medium
-- Company    : Visa
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_percentile_spenders
-- ======================================================================

/*
Return the user IDs and total spend for customers who fall in the top 1% by total transaction amount over the last 7 days.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'total_spend']:
  [876, 1447.8]
*/


-- Write your SQL solution below:

SELECT user_id, total_spend
FROM (
  SELECT
    user_id,
    SUM(total_amount) AS total_spend,
    NTILE(100) OVER (ORDER BY SUM(total_amount) DESC) AS pctl
  FROM transactions
  WHERE transaction_date >= DATE('now', '-7 days')
  GROUP BY user_id
) ranked
WHERE pctl = 1
