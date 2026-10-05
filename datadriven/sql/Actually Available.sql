-- ======================================================================
-- Actually Available
-- ======================================================================
-- Difficulty : Easy
-- Company    : Yelp
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/in_stock_product_count
-- ======================================================================

/*
The warehouse team is reconciling physical inventory against the catalog. How many products are currently marked as in stock?

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['in_stock_count']:
  [158]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS in_stock_count
FROM products
WHERE in_stock = 1
