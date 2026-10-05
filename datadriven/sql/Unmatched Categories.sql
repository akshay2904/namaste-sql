-- ======================================================================
-- Unmatched Categories
-- ======================================================================
-- Difficulty : Easy
-- Company    : DoubleVerify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unmatched_categories
-- ======================================================================

/*
Which product categories have zero products currently in stock? These represent gaps where customers can browse but cannot buy.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category']:
  ['Music']
*/


-- Write your SQL solution below:

SELECT category
FROM products
GROUP BY category
HAVING SUM(in_stock) = 0
