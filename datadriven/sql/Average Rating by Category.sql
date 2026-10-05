-- ======================================================================
-- Average Rating by Category
-- ======================================================================
-- Difficulty : Easy
-- Company    : Yelp
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_rating_by_category
-- ======================================================================

/*
Before the next product roadmap meeting, the PM wants to know which categories customers love and which ones need attention. Show the average product rating for each category.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'avg_rating']:
  ['Automotive', 3.431578947368421]
  ['Sports', 3.426315789473684]
  ['Books', 2.9611111111111112]
  ['Beauty', 2.936842105263158]
  ['Clothing', 2.9263157894736844]
*/


-- Write your SQL solution below:

SELECT
    category,
    AVG(rating) AS avg_rating
FROM products
GROUP BY category
ORDER BY avg_rating DESC, category
