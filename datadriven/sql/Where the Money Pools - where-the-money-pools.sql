-- ======================================================================
-- Where the Money Pools
-- ======================================================================
-- Difficulty : Medium
-- Company    : Visa
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/where-the-money-pools
-- ======================================================================

/*
We run a card-payments platform, and merchandising wants to see where this year's spend is concentrating across product categories. For each category, show its 2026 revenue and that revenue as a plain fraction of the year's total spend (a value between 0 and 1, not rounded), biggest categories first.

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

Expected output ['category', 'category_revenue', 'revenue_share']:
  ['Electronics', 15016.8, 0.19796091086696882]
  ['Toys', 12168.12, 0.16040781782660626]
  ['Books', 6137.94, 0.08091418899144975]
  ['Clothing', 6124.47, 0.0807366189719131]
  ['Home & Kitchen', 6111, 0.08055904895237644]
*/


-- Write your SQL solution below:

SELECT p.category AS category,
       SUM(t.total_amount) AS category_revenue,
       SUM(t.total_amount) * 1.0 / SUM(SUM(t.total_amount)) OVER () AS revenue_share
FROM transactions t
JOIN products p ON t.product_id = p.product_id
WHERE strftime('%Y', t.transaction_date) = '2026'
GROUP BY p.category
ORDER BY category_revenue DESC
