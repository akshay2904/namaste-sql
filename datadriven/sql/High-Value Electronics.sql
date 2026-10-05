-- ======================================================================
-- High-Value Electronics
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/high_value_electronics
-- ======================================================================

/*
The procurement team is reviewing what it costs to stock the electronics shelf. They want to see the name and price of in-stock electronics priced above two hundred dollars. Show only the five most expensive options, listed from highest price to lowest.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'price']:
  ['Basic Set v100', 1859.72]
  ['Basic Set v80', 1674.32]
  ['Basic Set v70', 1581.62]
  ['Basic Set v60', 1488.92]
  ['Basic Set v50', 1396.22]
*/


-- Write your SQL solution below:

SELECT product_name, price FROM products WHERE category = 'Electronics' AND price > 200 AND in_stock = 1 ORDER BY price DESC LIMIT 5
