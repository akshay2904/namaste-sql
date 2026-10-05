-- ======================================================================
-- Product Revenue Ranking
-- ======================================================================
-- Difficulty : Easy
-- Company    : FinThrive
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/product_revenue_ranking
-- ======================================================================

/*
The merchandising team is selecting the top 5 revenue drivers for a homepage feature. Show the product name, category, and total revenue for each, sorted from highest to lowest.

Table: products(product_id, product_name, category, price, rating, in_stock)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['product_name', 'category', 'total_revenue']:
  ['Premium Widget 100X', 'Electronics', 2713.98]
  ['Eco Kit 98X', 'Garden', 2660.1]
  ['Smart Gadget 97X', 'Automotive', 2633.16]
  ['Classic System 96X', 'Beauty', 2606.22]
  ['Essential Set 95X', 'Toys', 2579.28]
*/


-- Write your SQL solution below:

SELECT p.product_name, p.category, SUM(t.total_amount) AS total_revenue
FROM products p
JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 5
