-- ======================================================================
-- Clean Averages
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/clean_averages
-- ======================================================================

/*
The merchandising team is benchmarking product quality across the catalog. For each category, they need the average customer rating rounded to one decimal place, but only for products that have actually received a rating. Leave out any category with fewer than three rated products. List the results from highest average rating to lowest.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'avg_rating']:
  ['Automotive', 3.4]
  ['Books', 3]
  ['Beauty', 2.9]
  ['Electronics', 2.8]
  ['Music', 2.7]
*/


-- Write your SQL solution below:

SELECT category, ROUND(AVG(rating), 1) AS avg_rating
FROM products
WHERE rating IS NOT NULL
GROUP BY category
HAVING COUNT(rating) >= 3
ORDER BY avg_rating DESC, category ASC
