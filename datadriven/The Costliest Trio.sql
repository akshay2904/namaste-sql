-- ======================================================================
-- The Costliest Trio
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/three_item_combinations
-- ======================================================================

/*
We're building a gift-bundle recommender for a retail catalog, where every bundle is three different products and its price is the sum of the three item costs. Surface the 100 most expensive bundles, listing each bundle's three product names alphabetically in one comma-separated string next to its combined price.

Table: products(product_name, price)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['combo', 'total_cost']:
  ['Basic Set v100,Premium Widget v99,Turbo Set v98', 5551.35]
  ['Basic Set v100,Eco Widget v97,Premium Widget v99', 5542.08]
  ['Basic Set v100,Eco Widget v97,Turbo Set v98', 5532.81]
  ['Basic Set v100,Premium Widget v99,Smart Set v96', 5532.81]
  ['Basic Set v100,Classic Widget v95,Premium Widget v99', 5523.54]
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT product_name, price
  FROM products
  WHERE price IS NOT NULL
  ORDER BY price DESC
  LIMIT 200
)
SELECT a.product_name || ',' || b.product_name || ',' || c.product_name AS combo,
       a.price + b.price + c.price AS total_cost
FROM ranked a
JOIN ranked b ON a.product_name < b.product_name
JOIN ranked c ON b.product_name < c.product_name
ORDER BY total_cost DESC, combo ASC
LIMIT 100
