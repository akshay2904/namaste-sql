-- ======================================================================
-- Ebb and Flow
-- ======================================================================
-- Difficulty : Hard
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_revenue_change
-- ======================================================================

/*
A finance team tracks revenue momentum by watching how each month stacks up against the one before it. Total each month's transaction revenue and show how it moved, in percent, from the immediately preceding month.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['month', 'revenue', 'pct_change']:
  ['2022-01', 855.12, None]
  ['2022-02', 1528.62, 78.76]
  ['2022-03', 696.96, -54.41]
  ['2022-04', 1259.22, 80.67]
  ['2022-05', 562.26, -55.35]
*/


-- Write your SQL solution below:

WITH monthly AS (
    SELECT STRFTIME('%Y-%m', transaction_date) AS month,
           SUM(total_amount) AS revenue
    FROM transactions
    GROUP BY STRFTIME('%Y-%m', transaction_date)
),
sequenced AS (
    SELECT month,
           revenue,
           LAG(revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly
)
SELECT month,
       ROUND(revenue, 2) AS revenue,
       CASE
           WHEN prev_revenue IS NULL THEN NULL
           WHEN prev_revenue = 0    THEN NULL
           ELSE ROUND((revenue - prev_revenue) * 100.0 / prev_revenue, 2)
       END AS pct_change
FROM sequenced
ORDER BY month;
