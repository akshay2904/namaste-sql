-- ======================================================================
-- The Above Average
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/above_category_avg
-- ======================================================================

/*
The pricing team is flagging products that look overpriced relative to their own category. For every product whose listed price exceeds the average price within its category, return the product name, category, price, and that category's average price.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'category', 'price', 'avg_price']:
  ['Deluxe Widget v1', 'Books', 941.99, 857.7549999999999]
  ['Pro Set v2', 'Clothing', 951.26, 832.4021052631579]
  ['Ultra Widget v3', 'Home & Kitchen', 960.53, 874.555]
  ['Essential Set v4', 'Sports', 969.8, 882.9549999999999]
  ['Classic Widget v5', 'Toys', 979.07, 854.505]
*/


-- Write your SQL solution below:

WITH category_avgs AS (
    SELECT category, AVG(price) AS avg_price
    FROM products
    GROUP BY category
)
SELECT
    p.product_name,
    p.category,
    p.price,
    ca.avg_price
FROM products p
JOIN category_avgs ca ON p.category = ca.category
WHERE p.price > ca.avg_price
