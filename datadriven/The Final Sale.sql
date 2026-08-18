-- ======================================================================
-- The Final Sale
-- ======================================================================
-- Difficulty : Medium
-- Company    : Databricks
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_latest_transaction_per_product
-- ======================================================================

/*
The catalog dashboard needs every product that has sold paired with its newest sale, since some products have hundreds of transactions but only the most recent one belongs on the page. Show each product's name and category alongside that latest sale's amount and date.

Table: products(product_id, product_name, category, price)

Table: transactions(transaction_id, product_id, user_id, total_amount, quantity, transaction_date)

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

Expected output ['product_name', 'category', 'latest_sale_amount', 'last_sale_date']:
  ['Basic Device 1X', 'Books', 23.46, '2026-02-02']
  ['Basic Device 21X', 'Books', 292.86, '2026-10-22']
  ['Basic Device 31X', 'Books', 427.56, '2026-08-04']
  ['Basic Device 41X', 'Books', 562.26, '2026-06-14']
  ['Basic Device 51X', 'Books', 696.96, '2026-04-24']
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT product_id,
           total_amount,
           transaction_date,
           ROW_NUMBER() OVER (
               PARTITION BY product_id
               ORDER BY transaction_date DESC, transaction_id DESC
           ) AS rn
    FROM transactions
)
SELECT p.product_name,
       p.category,
       r.total_amount     AS latest_sale_amount,
       r.transaction_date AS last_sale_date
FROM products p
JOIN ranked r ON r.product_id = p.product_id
WHERE r.rn = 1
ORDER BY p.product_name, p.product_id
