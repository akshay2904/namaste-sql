-- ======================================================================
-- Profitable Categories by Price
-- ======================================================================
-- Difficulty : Easy
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/profitable_categories_by_price
-- ======================================================================

/*
Show each category that has a positive average rating, along with the lowest price in that category and the average rating, ranked from cheapest up.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'min_price', 'avg_rating']:
  ['Books', 17.52, 2.9611111111111112]
  ['Clothing', 25.05, 2.9263157894736844]
  ['Home & Kitchen', 32.58, 2.7944444444444443]
  ['Sports', 40.11, 3.426315789473684]
  ['Toys', 47.64, 2.710526315789474]
*/


-- Write your SQL solution below:

SELECT
    category,
    MIN(price) AS min_price,
    AVG(rating) AS avg_rating
FROM products
GROUP BY category
HAVING AVG(rating) > 0
ORDER BY min_price ASC
