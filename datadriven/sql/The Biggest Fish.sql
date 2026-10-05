-- ======================================================================
-- The Biggest Fish
-- ======================================================================
-- Difficulty : Medium
-- Company    : Barclays
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-biggest-fish
-- ======================================================================

/*
A loyalty team wants the customer who spends the most in each product category so they can plan outreach. For every category, return that customer and their total spend across the category.

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

Expected output ['category', 'user_id', 'total_spent']:
  ['Automotive', 779, 5683.44]
  ['Beauty', 1167, 4585.86]
  ['Books', 197, 5036.88]
  ['Clothing', 294, 5144.64]
  ['Electronics', 1070, 6006.72]
*/


-- Write your SQL solution below:

WITH category_spend AS (
  SELECT p.category AS category,
         t.user_id AS user_id,
         SUM(t.total_amount) AS total_spent
  FROM transactions t
  JOIN products p ON t.product_id = p.product_id
  GROUP BY p.category, t.user_id
),
ranked AS (
  SELECT category,
         user_id,
         total_spent,
         RANK() OVER (PARTITION BY category ORDER BY total_spent DESC) AS spend_rank
  FROM category_spend
)
SELECT category, user_id, total_spent
FROM ranked
WHERE spend_rank = 1
ORDER BY category, user_id
