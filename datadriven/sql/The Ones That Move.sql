-- ======================================================================
-- The Ones That Move
-- ======================================================================
-- Difficulty : Medium
-- Company    : DoorDash
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-ones-that-move
-- ======================================================================

/*
The merchandising team wants to know which products carry each category by sales, where a product's revenue is its quantity times unit price summed across every order line. For each category return its three strongest products, showing the category, the product name, that revenue, and the product's standing within the category, ordered by category, then standing, then product name.

Table: order_items(item_id, order_id, product_id, user_id, quantity, unit_price)

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - order_items ['item_id', 'order_id', 'product_id', 'user_id', 'quantity', 'unit_price']:
  [6061, 10388, 1344, 1167, 4, 22.3]
  [6122, 10679, 1687, 2234, 7, 39.6]
  [6183, 10970, 2030, 3301, 10, 56.9]
  [6244, 11261, 2373, 4368, 3, 74.2]
  [6305, 11552, 2716, 5435, 6, 91.5]

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'product_name', 'revenue', 'revenue_rank']:
  ['Automotive', 'Smart Gadget 97X', 4894, 1]
  ['Automotive', 'Smart Gadget 47X', 3544, 2]
  ['Automotive', 'Smart Gadget 37X', 3354, 3]
  ['Beauty', 'Classic System 96X', 5706, 1]
  ['Beauty', 'Classic System 86X', 5478, 2]
*/


-- Write your SQL solution below:

WITH product_revenue AS (
  SELECT p.category,
         p.product_name,
         SUM(oi.quantity * oi.unit_price) AS revenue
  FROM order_items oi
  JOIN products p ON p.product_id = oi.product_id
  GROUP BY p.category, p.product_name
),
ranked AS (
  SELECT category,
         product_name,
         revenue,
         DENSE_RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS revenue_rank
  FROM product_revenue
)
SELECT category, product_name, revenue, revenue_rank
FROM ranked
WHERE revenue_rank <= 3
ORDER BY category, revenue_rank, product_name;
