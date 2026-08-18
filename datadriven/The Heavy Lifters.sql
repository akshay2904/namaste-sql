-- ======================================================================
-- The Heavy Lifters
-- ======================================================================
-- Difficulty : Medium
-- Company    : Burtch Works
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/categories_with_mixed_price_tiers
-- ======================================================================

/*
A merchandising team treats any order of three or more units as a bulk order and wants to find the categories that lean on them. Return the categories where bulk orders account for more than half of total revenue, giving just the category name.

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

Expected output ['category']:
  ['Automotive']
  ['Clothing']
  ['Garden']
  ['Home & Kitchen']
  ['Music']
*/


-- Write your SQL solution below:

SELECT p.category
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.category
HAVING SUM(CASE WHEN t.quantity >= 3 THEN t.total_amount ELSE 0 END) > 0.5 * SUM(t.total_amount)
ORDER BY p.category
