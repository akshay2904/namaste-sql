-- ======================================================================
-- Stock Status
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/stock_status
-- ======================================================================

/*
The storefront team is redesigning product tiles and wants a clean availability label on each one. For every product, output the product name, category, price, and a label that reads 'In Stock' when the item is available and 'Out of Stock' otherwise. Only include products that have a price on file, ordered alphabetically by product name.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'category', 'price', 'availability']:
  ['Basic Device 11X', 'Books', 92.82, 'In Stock']
  ['Basic Device 1X', 'Books', 17.52, 'In Stock']
  ['Basic Device 21X', 'Books', 168.12, 'Out of Stock']
  ['Basic Device 31X', 'Books', 243.42, 'In Stock']
  ['Basic Device 91X', 'Books', 695.22, 'Out of Stock']
*/


-- Write your SQL solution below:

SELECT product_name, category, price, CASE WHEN in_stock = 1 THEN 'In Stock' ELSE 'Out of Stock' END AS availability
FROM products
WHERE price IS NOT NULL
ORDER BY product_name
