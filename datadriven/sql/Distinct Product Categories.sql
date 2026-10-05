-- ======================================================================
-- Distinct Product Categories
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/distinct_product_categories
-- ======================================================================

/*
The merchandising team is mapping out the full product taxonomy. Pull a deduplicated list of every product category currently in the catalog.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category']:
  ['Books']
  ['Clothing']
  ['Home & Kitchen']
  ['Sports']
  ['Toys']
*/


-- Write your SQL solution below:

SELECT DISTINCT category
FROM products
