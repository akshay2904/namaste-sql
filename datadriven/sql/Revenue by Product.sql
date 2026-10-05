-- ======================================================================
-- Revenue by Product
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/revenue_by_product
-- ======================================================================

/*
The general manager is preparing the annual product performance review. For each product, show the product name, total revenue generated, and the number of units sold. Only include products that have generated at least one hundred dollars in total revenue, ordered from the highest revenue product to the lowest.

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

Expected output ['product_name', 'total_revenue', 'units_sold']:
  ['Premium Widget 100X', 2713.98, 2]
  ['Eco Kit 98X', 2660.1, 8]
  ['Smart Gadget 97X', 2633.16, 6]
  ['Classic System 96X', 2606.22, 4]
  ['Ultra Tool 94X', 2552.34, 10]
*/


-- Write your SQL solution below:

SELECT p.product_name, SUM(t.total_amount) AS total_revenue, SUM(t.quantity) AS units_sold
FROM products p
JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.product_name
HAVING SUM(t.total_amount) >= 100
ORDER BY total_revenue DESC
