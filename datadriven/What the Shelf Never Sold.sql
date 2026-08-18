-- ======================================================================
-- What the Shelf Never Sold
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/revenue_per_product_with_zeros
-- ======================================================================

/*
A merchandising team needs a revenue report spanning the whole catalog, where a product's revenue is the total amount buyers were charged across all of its sales. List every product with that revenue rounded to two decimals, and a product that never sold a single unit should read zero.

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

Expected output ['product_id', 'product_name', 'total_revenue']:
  [1001, 'Basic Device 1X', 46.92]
  [1050, 'Deluxe Bundle 2X', 73.86]
  [1099, 'Pro Unit 3X', 100.8]
  [1148, 'Ultra Tool 4X', 127.74]
  [1197, 'Essential Set 5X', 154.68]
*/


-- Write your SQL solution below:

SELECT p.product_id,
       p.product_name,
       ROUND(COALESCE(SUM(t.total_amount), 0), 2) AS total_revenue
FROM products p
LEFT JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_id
