-- ======================================================================
-- Double or Nothing
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/price_pairs
-- ======================================================================

/*
A pricing analyst is flagging products on the same shelf that carry wildly different stickers. Within each category, find every pair where one product costs at least twice the other, listing each pair only once.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_1', 'product_2', 'category', 'price_1', 'price_2']:
  ['Basic Device 1X', 'Basic Device 11X', 'Books', 17.52, 92.82]
  ['Basic Device 1X', 'Basic Device 21X', 'Books', 17.52, 168.12]
  ['Basic Device 1X', 'Basic Device 31X', 'Books', 17.52, 243.42]
  ['Basic Device 1X', 'Basic Device 41X', 'Books', 17.52, 318.72]
  ['Basic Device 1X', 'Basic Device 51X', 'Books', 17.52, 394.02]
*/


-- Write your SQL solution below:

SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    p1.category,
    p1.price AS price_1,
    p2.price AS price_2
FROM products p1
JOIN products p2
  ON p1.category = p2.category
  AND p1.product_id < p2.product_id
WHERE p1.price >= 2 * p2.price
   OR p2.price >= 2 * p1.price
