-- ======================================================================
-- Price Rank
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/price_rank
-- ======================================================================

/*
The catalog team wants competitive price positioning inside each category. Within each category, rank products by price with the most expensive at position 1, and let ties share a position. Skip rows where price is NULL. Return the product_name, category, price, and its position.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'category', 'price', 'position']:
  ['Eco Widget v97', 'Automotive', 1831.91, 1]
  ['Eco Widget v87', 'Automotive', 1739.21, 2]
  ['Eco Widget v77', 'Automotive', 1646.51, 3]
  ['Eco Widget v67', 'Automotive', 1553.81, 4]
  ['Eco Widget v57', 'Automotive', 1461.11, 5]
*/


-- Write your SQL solution below:

SELECT product_name, category, price, rnk AS position
FROM (
    SELECT
        product_name,
        category,
        price,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS rnk
    FROM products
    WHERE price IS NOT NULL
) ranked
