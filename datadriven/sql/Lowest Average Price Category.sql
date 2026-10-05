-- ======================================================================
-- Lowest Average Price Category
-- ======================================================================
-- Difficulty : Easy
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/lowest_average_price_category
-- ======================================================================

/*
The pricing team wants to identify the most budget-friendly segment of the catalog. Which product category has the lowest average price?

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'avg_price']:
  ['Clothing', 832.4021052631579]
*/


-- Write your SQL solution below:

SELECT category, AVG(price) AS avg_price
FROM products
GROUP BY category
ORDER BY avg_price ASC
LIMIT 1
