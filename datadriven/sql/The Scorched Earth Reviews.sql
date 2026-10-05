-- ======================================================================
-- The Scorched Earth Reviews
-- ======================================================================
-- Difficulty : Easy
-- Company    : Yelp
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/one_star_product_review_count
-- ======================================================================

/*
The quality assurance team is pulling all products that received the lowest possible rating (1) to investigate whether there's a common defect. Show each product's name and rating.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'rating']:
  ['Premium Widget 40X', 1]
  ['Premium Widget 80X', 1]
  ['Deluxe Widget v21', 1]
  ['Deluxe Widget v61', 1]
*/


-- Write your SQL solution below:

SELECT product_name, rating
FROM products
WHERE rating = 1
