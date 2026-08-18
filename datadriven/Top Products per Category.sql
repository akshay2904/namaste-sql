-- ======================================================================
-- Top Products per Category
-- ======================================================================
-- Difficulty : Medium
-- Company    : Visa
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_products_per_category
-- ======================================================================

/*
For each product category, pull the top 5 products by total sales revenue. The data lives across the transactions and products tables. Return the category, product name, and total sales.

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

Expected output ['category', 'product_name', 'total_sales']:
  ['Automotive', 'Smart Gadget 97X', 2633.16]
  ['Automotive', 'Smart Gadget 87X', 2363.76]
  ['Automotive', 'Smart Gadget 67X', 1824.96]
  ['Automotive', 'Smart Gadget 57X', 1555.56]
  ['Automotive', 'Smart Gadget 47X', 1286.16]
*/


-- Write your SQL solution below:

WITH product_sales AS (
    SELECT p.category, p.product_name, SUM(t.total_amount) AS total_sales
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id
    GROUP BY p.category, p.product_name
),
ranked AS (
    SELECT category, product_name, total_sales,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_sales DESC, product_name) AS rn
    FROM product_sales
)
SELECT category, product_name, total_sales
FROM ranked
WHERE rn <= 5
ORDER BY category, total_sales DESC, product_name
