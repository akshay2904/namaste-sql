-- ======================================================================
-- Top Selling Items
-- ======================================================================
-- Difficulty : Easy
-- Company    : FinThrive
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_selling_items
-- ======================================================================

/*
Pull the top 5 revenue-generating products across the entire catalog. Show the product name and total revenue.

Table: products(product_id, product_name)

Table: transactions(transaction_id, product_id, total_amount)

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

Expected output ['product_name', 'total_revenue']:
  ['Premium Widget 100X', 2713.98]
  ['Eco Kit 98X', 2660.1]
  ['Smart Gadget 97X', 2633.16]
  ['Classic System 96X', 2606.22]
  ['Essential Set 95X', 2579.28]
*/


-- Write your SQL solution below:

SELECT p.product_name, SUM(t.total_amount) AS total_revenue
FROM products p
JOIN transactions t ON t.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC, p.product_name ASC
LIMIT 5
