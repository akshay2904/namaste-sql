-- ======================================================================
-- High-Rated In-Stock Percentage
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/high_rated_in_stock_percentage
-- ======================================================================

/*
The merchandising lead wants a single number for the board slide: what percentage of the entire catalog is both in stock and rated 4 or above?

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['pct_in_stock_high_rated']:
  [15.5]
*/


-- Write your SQL solution below:

SELECT ROUND(
    AVG(CASE WHEN in_stock = 1 AND rating >= 4.0 THEN 1.0 ELSE 0.0 END) * 100, 2
) AS pct_in_stock_high_rated
FROM products
