-- ======================================================================
-- Kings of the Calendar
-- ======================================================================
-- Difficulty : Hard
-- Company    : eBay
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/best_selling_product_by_month
-- ======================================================================

/*
We publish a monthly leaderboard of the best-selling products for an online marketplace, where selling is measured by total units sold in each calendar month. For every month, return the top 10 products with their total units sold and standing, counting only completed sales by dropping any transaction with a negative `total_amount` (those are refunds), with the oldest month first.

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

Expected output ['month', 'product_name', 'total_quantity', 'rnk']:
  ['2022-01', 'Basic Device 61X', 2, 1]
  ['2023-01', 'Smart Gadget 97X', 3, 1]
  ['2024-01', 'Pro Unit 73X', 4, 1]
  ['2025-01', 'Turbo Pack 49X', 5, 1]
  ['2026-01', 'Premium Widget 60X', 1, 5]
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT
        STRFTIME('%Y-%m', transaction_date) AS month, b.product_name,
        SUM(quantity) AS total_quantity,
        DENSE_RANK() OVER (PARTITION BY STRFTIME('%Y-%m', transaction_date) ORDER BY SUM(quantity) DESC) AS rnk
    FROM transactions a
JOIN products b ON a.product_id = b.product_id
WHERE total_amount >= 0
    GROUP BY STRFTIME('%Y-%m', transaction_date), b.product_name
)
SELECT *
FROM ranked
WHERE rnk <= 10
ORDER BY month, rnk
