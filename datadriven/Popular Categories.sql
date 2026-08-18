-- ======================================================================
-- Popular Categories
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/popular_categories
-- ======================================================================

/*
The merchandising team is negotiating shelf-space contracts and only wants to discuss product categories that have meaningful scale. For each category, show the number of products, the average rating, and the average price. Only include categories with more than eight products. Present them from highest average rating to lowest.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'product_count', 'avg_rating', 'avg_price']:
  ['Automotive', 20, 3.431578947368421, 932.8368421052633]
  ['Sports', 20, 3.426315789473684, 882.9549999999999]
  ['Books', 20, 2.9611111111111112, 857.7549999999999]
  ['Beauty', 20, 2.936842105263158, 907.3216666666667]
  ['Clothing', 20, 2.9263157894736844, 832.4021052631579]
*/


-- Write your SQL solution below:

SELECT
    category,
    COUNT(*) AS product_count,
    AVG(rating) AS avg_rating,
    AVG(price) AS avg_price
FROM products
GROUP BY category
HAVING COUNT(*) > 8
ORDER BY avg_rating DESC
