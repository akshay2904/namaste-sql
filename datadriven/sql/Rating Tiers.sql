-- ======================================================================
-- Rating Tiers
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/rating_tiers
-- ======================================================================

/*
The review team wants product ratings tiered inside each category with no gaps on ties. Within each category, rank products by rating with the highest rating at position 1; tied ratings share a position, and the next rating down takes the immediately following position. Skip products with no rating. Return the product_name, category, rating, and position.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'category', 'rating', 'position']:
  ['Smart Gadget 7X', 'Automotive', 4.9, 1]
  ['Smart Gadget 47X', 'Automotive', 4.9, 1]
  ['Smart Gadget 87X', 'Automotive', 4.9, 1]
  ['Eco Widget v27', 'Automotive', 4.8, 2]
  ['Eco Widget v67', 'Automotive', 4.8, 2]
*/


-- Write your SQL solution below:

SELECT
    product_name,
    category,
    rating,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY CAST(rating AS DOUBLE) DESC) AS position
FROM products
WHERE rating IS NOT NULL
