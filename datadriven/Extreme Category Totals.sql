-- ======================================================================
-- Extreme Category Totals
-- ======================================================================
-- Difficulty : Medium
-- Company    : PayU
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/extreme_category_totals
-- ======================================================================

/*
From this calendar year's transactions, find the product categories with the highest total sales and the lowest total sales. Combine transactions with products to get the category. Return both category names and their totals.

Table: transactions(transaction_id, product_id, total_amount, transaction_date)

Table: products(product_id, category)

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

Expected output ['category', 'total']:
  ['Electronics', 15016.8]
  ['Music', 6030.18]
*/


-- Write your SQL solution below:

WITH yearly AS (
  SELECT p.category, SUM(t.total_amount) AS total
  FROM transactions t
  JOIN products p ON t.product_id = p.product_id
  WHERE strftime('%Y', t.transaction_date) = CAST(CAST(strftime('%Y', 'now') AS INTEGER) - 0 AS TEXT)
  GROUP BY p.category
)
SELECT category, total
FROM yearly
WHERE total = (SELECT MAX(total) FROM yearly)
   OR total = (SELECT MIN(total) FROM yearly)
