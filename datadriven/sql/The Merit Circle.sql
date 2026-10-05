-- ======================================================================
-- The Merit Circle
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_10_rated_products
-- ======================================================================

/*
Each product may carry many reviews, but the `rating` column already holds the product's average. Bring back the ten highest-rated products, from best to worst.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'rating']:
  ['Essential Set v24', 4.9]
  ['Essential Set v64', 4.9]
  ['Smart Gadget 47X', 4.9]
  ['Eco Widget v27', 4.8]
  ['Eco Widget v67', 4.8]
*/


-- Write your SQL solution below:

SELECT product_name, rating
FROM products
WHERE rating IS NOT NULL
ORDER BY rating DESC, product_name ASC
LIMIT 10;
