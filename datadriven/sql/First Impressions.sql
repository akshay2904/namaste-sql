-- ======================================================================
-- First Impressions
-- ======================================================================
-- Difficulty : Easy
-- Company    : Oracle
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/product_name_prefix
-- ======================================================================

/*
Show each product's ID next to just the first three characters of its name, ordered by product ID.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_id', 'name_prefix']:
  [1001, 'Bas']
  [1050, 'Del']
  [1099, 'Pro']
  [1148, 'Ult']
  [1197, 'Ess']
*/


-- Write your SQL solution below:

SELECT product_id, SUBSTR(product_name, 1, 3) AS name_prefix
FROM products
ORDER BY product_id
