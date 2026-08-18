-- ======================================================================
-- Top Five
-- ======================================================================
-- Difficulty : Easy
-- Company    : Tata Consultancy Services
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_five
-- ======================================================================

/*
The editorial team is assembling a buyer's guide and needs the five most expensive products for the luxury highlight section. Show the product name, category, price, and whether the item is currently available. Products without a listed price should be excluded.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'category', 'price', 'in_stock']:
  ['Basic Set v100', 'Electronics', 1859.72, 1]
  ['Premium Widget v99', 'Music', 1850.45, 0]
  ['Turbo Set v98', 'Garden', 1841.18, 1]
  ['Eco Widget v97', 'Automotive', 1831.91, 1]
  ['Smart Set v96', 'Beauty', 1822.64, 1]
*/


-- Write your SQL solution below:

SELECT product_name, category, price, in_stock
FROM products
WHERE price IS NOT NULL
ORDER BY price DESC, product_name ASC
LIMIT 5
