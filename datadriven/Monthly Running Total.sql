-- ======================================================================
-- Monthly Running Total
-- ======================================================================
-- Difficulty : Medium
-- Company    : Merilytics
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_running_total
-- ======================================================================

/*
For each product, show the monthly sales total alongside a running cumulative total that accumulates across months, by product then month. Only include transactions that are attributed to a product (exclude rows with no product_id).

Table: transactions(transaction_id, product_id, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['product_id', 'month', 'monthly_total', 'cumulative_total']:
  [1001, '2022-01', 23.46, 23.46]
  [1001, '2026-02', 23.46, 46.92]
  [1050, '2023-02', 36.93, 36.93]
  [1050, '2026-03', 36.93, 73.86]
  [1099, '2024-03', 50.4, 50.4]
*/


-- Write your SQL solution below:

WITH monthly AS (
  SELECT
    product_id,
    strftime('%Y-%m', transaction_date) AS month,
    SUM(total_amount) AS monthly_total
  FROM transactions
  WHERE product_id IS NOT NULL
  GROUP BY product_id, strftime('%Y-%m', transaction_date)
)
SELECT
  product_id,
  month,
  monthly_total,
  SUM(monthly_total) OVER (PARTITION BY product_id ORDER BY month) AS cumulative_total
FROM monthly
ORDER BY product_id, month
