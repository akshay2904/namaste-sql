-- ======================================================================
-- Products With Strong Unit Price
-- ======================================================================
-- Difficulty : Medium
-- Company    : IBM
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/products_with_strong_unit_price
-- ======================================================================

/*
Find products with at least 1 purchase and a unit-weighted average price (total amount divided by quantity) of at least $100. Pull the product name from the products table and return it in lowercase. Return the product ID, product name (lowercased), and average unit price.

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

Expected output ['product_id', 'product_name', 'avg_unit_price']:
  [1442, 'premium widget 10x', 144.69]
  [1687, 'essential set 15x', 212.04]
  [1736, 'classic system 16x', 112.755]
  [1932, 'premium widget 20x', 279.39]
  [1981, 'basic device 21x', 146.43]
*/


-- Write your SQL solution below:

SELECT t.product_id,
       LOWER(p.product_name) AS product_name,
       SUM(t.total_amount) / SUM(t.quantity) AS avg_unit_price
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY t.product_id, p.product_name
HAVING SUM(t.total_amount) / SUM(t.quantity) >= 100
ORDER BY t.product_id
