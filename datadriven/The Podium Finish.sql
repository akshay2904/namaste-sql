-- ======================================================================
-- The Podium Finish
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_podium_finish
-- ======================================================================

/*
For each category, return the top 2 products by total quantity sold. If products tie in quantity within a category, break the tie alphabetically by product name and assign consecutive ranks. Only include rows ranked 1 or 2.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'product_name', 'total_quantity', 'rank']:
  ['Automotive', 'Smart Gadget 17X', 6, 1]
  ['Beauty', 'Classic System 16X', 4, 1]
  ['Electronics', 'Premium Widget 100X', 2, 1]
  ['Garden', 'Eco Kit 18X', 8, 1]
  ['Music', 'Turbo Pack 19X', 10, 1]
*/


-- Write your SQL solution below:

WITH product_qty AS (
  SELECT p.category, p.product_name, SUM(t.quantity) AS total_quantity
  FROM transactions t INNER JOIN products p ON t.product_id = p.product_id
  GROUP BY p.category, p.product_name
),
ranked AS (
  SELECT category, product_name, total_quantity,
         ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_quantity DESC, product_name ASC) AS rank
  FROM product_qty
)
SELECT category, product_name, total_quantity, rank FROM ranked WHERE rank <= 2
ORDER BY category, rank
