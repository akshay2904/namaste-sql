-- ======================================================================
-- The Slow Build
-- ======================================================================
-- Difficulty : Medium
-- Company    : Audible
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cumulative_monthly_revenue_avg
-- ======================================================================

/*
For each month in 2026, show the total revenue and a running average of all months up to and including the current one, rounded to the nearest whole number.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['month', 'monthly_revenue', 'cumulative_avg']:
  ['2026-01', 7400.64, 7401]
  ['2026-02', 6713.67, 7057]
  ['2026-03', 7383.69, 7166]
  ['2026-04', 8178.42, 7419]
  ['2026-05', 7356.75, 7407]
*/


-- Write your SQL solution below:

SELECT month, monthly_revenue,
  CAST(ROUND(AVG(monthly_revenue) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) AS REAL) AS cumulative_avg
FROM (
  SELECT strftime('%Y-%m', transaction_date) AS month,
         SUM(total_amount) AS monthly_revenue
  FROM transactions
  WHERE strftime('%Y', transaction_date) = '2026'
  GROUP BY strftime('%Y-%m', transaction_date)
)
ORDER BY month
