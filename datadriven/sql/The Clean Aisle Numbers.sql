-- ======================================================================
-- The Clean Aisle Numbers
-- ======================================================================
-- Difficulty : Medium
-- Company    : PayPal
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deduplicated_sales_volume_by_category
-- ======================================================================

/*
The transactions table contains duplicate records. First deduplicate by keeping only the first occurrence of each transaction (the one with the lowest transaction_id when multiple rows share the same user_id, product_id, total_amount, and transaction_date). Then combine with the products table and compute the total sales amount per product category, only counting transactions where total_amount is positive.

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

Expected output ['category', 'total_sales']:
  ['Automotive', 12114.24]
  ['Beauty', 12141.18]
  ['Books', 12275.88]
  ['Clothing', 12248.94]
  ['Electronics', 15016.8]
*/


-- Write your SQL solution below:

WITH deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, product_id, total_amount, transaction_date
            ORDER BY transaction_id ASC
        ) AS rn
    FROM transactions
)
SELECT p.category, SUM(d.total_amount) AS total_sales
FROM deduped d
JOIN products p ON d.product_id = p.product_id
WHERE d.rn = 1
  AND d.total_amount > 0
GROUP BY p.category
