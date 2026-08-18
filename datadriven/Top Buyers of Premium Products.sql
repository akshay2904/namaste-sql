-- ======================================================================
-- Top Buyers of Premium Products
-- ======================================================================
-- Difficulty : Medium
-- Company    : Merilytics
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_buyers_of_premium_products
-- ======================================================================

/*
Rank all products by rating, keeping only those with a known rating, and take the top 10 tier. Then find every user who purchased one of those products and count how many unique purchases each user made from that tier. Show the top 10 users by purchase count.

Table: products(product_id, product_name, category, price, rating, in_stock)

Table: order_items(item_id, order_id, product_id, user_id, quantity, unit_price)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Sample data - order_items ['item_id', 'order_id', 'product_id', 'user_id', 'quantity', 'unit_price']:
  [6061, 10388, 1344, 1167, 4, 22.3]
  [6122, 10679, 1687, 2234, 7, 39.6]
  [6183, 10970, 2030, 3301, 10, 56.9]
  [6244, 11261, 2373, 4368, 3, 74.2]
  [6305, 11552, 2716, 5435, 6, 91.5]

Expected output ['user_id', 'purchase_count']:
  [9315, 2]
  [9121, 2]
  [8927, 2]
  [8733, 2]
  [8248, 2]
*/


-- Write your SQL solution below:

WITH top_rated AS (
  SELECT
    product_id,
    rating,
    DENSE_RANK() OVER (ORDER BY rating DESC) AS rnk
  FROM products
  WHERE rating IS NOT NULL
)
SELECT
  oi.user_id,
  COUNT(DISTINCT oi.item_id) AS purchase_count
FROM order_items oi
INNER JOIN top_rated tr
  ON oi.product_id = tr.product_id
WHERE tr.rnk <= 10
GROUP BY oi.user_id
ORDER BY purchase_count DESC
LIMIT 10
