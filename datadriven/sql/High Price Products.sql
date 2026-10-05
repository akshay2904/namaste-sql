-- ======================================================================
-- High Price Products
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/high_price_products
-- ======================================================================

/*
The procurement team is renegotiating supplier contracts and needs the full record for every product priced above 100.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [10752, 'Basic Set v100', 'Electronics', 1859.72, 3.7, 1]
  [10703, 'Premium Widget v99', 'Music', 1850.45, 2.4, 0]
  [10654, 'Turbo Set v98', 'Garden', 1841.18, 1.1, 1]
  [10605, 'Eco Widget v97', 'Automotive', 1831.91, 3.8, 1]
  [10262, 'Basic Set v90', 'Electronics', 1767.02, 2.7, 0]
*/


-- Write your SQL solution below:

SELECT *
FROM products
WHERE price > 100
ORDER BY price DESC, product_id
