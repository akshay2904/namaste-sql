-- ======================================================================
-- Median Transaction by Category
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/median_transaction_by_category
-- ======================================================================

/*
Compute the median transaction amount for each product category. Show each category alongside its median.

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

Expected output ['category', 'median_amount']:
  ['Automotive', 643.08]
  ['Beauty', 629.61]
  ['Books', 696.96]
  ['Clothing', 710.43]
  ['Electronics', 750.84]
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT p.category, t.total_amount,
         ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY t.total_amount) AS rn,
         COUNT(*) OVER (PARTITION BY p.category) AS cnt
  FROM transactions t INNER JOIN products p ON t.product_id = p.product_id
)
SELECT category, AVG(total_amount) AS median_amount
FROM ranked
WHERE rn IN ((cnt + 1) / 2, (cnt + 2) / 2)
GROUP BY category
ORDER BY category
