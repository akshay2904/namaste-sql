-- ======================================================================
-- Category Census
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/category_census
-- ======================================================================

/*
The warehouse team is prepping inventory numbers for the quarterly review. They need to see how many products sit in each category, but only categories that carry more than eight items are worth discussing. Show the category and the product tally, sorted from largest category to smallest.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'product_count']:
  ['Toys', 20]
  ['Sports', 20]
  ['Music', 20]
  ['Home & Kitchen', 20]
  ['Garden', 20]
*/


-- Write your SQL solution below:

SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING COUNT(*) > 8
ORDER BY product_count DESC
