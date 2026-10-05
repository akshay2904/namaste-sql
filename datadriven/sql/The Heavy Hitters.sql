-- ======================================================================
-- The Heavy Hitters
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/best_selling_reps_each_month
-- ======================================================================

/*
We're putting together a revenue leaderboard for the product catalog, where a product's standing is its total transaction amount across every sale. Publish the top 10 products, biggest earners first, each shown with its name, its total, and its position on the board.

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

Expected output ['product_name', 'total_total_amount', 'rnk']:
  ['Premium Widget 100X', 2713.98, 1]
  ['Eco Kit 98X', 2660.1, 2]
  ['Smart Gadget 97X', 2633.16, 3]
  ['Classic System 96X', 2606.22, 4]
  ['Essential Set 95X', 2579.28, 5]
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT
        b.product_name,
        SUM(total_amount) AS total_total_amount,
        DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rnk
    FROM transactions a
JOIN products b ON a.product_id = b.product_id
    GROUP BY b.product_name
)
SELECT *
FROM ranked
WHERE rnk <= 10
ORDER BY rnk
