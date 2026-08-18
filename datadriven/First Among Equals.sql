-- ======================================================================
-- First Among Equals
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_ordered_product_by_country
-- ======================================================================

/*
The merchandising team wants the catalog's bestseller. Find every product with the highest number of recorded transactions, and show the product name and that count.

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

Expected output ['product_name', 'order_count']:
  ['Basic Device 1X', 2]
  ['Basic Device 21X', 2]
  ['Basic Device 31X', 2]
  ['Basic Device 41X', 2]
  ['Basic Device 51X', 2]
*/


-- Write your SQL solution below:

SELECT p.product_name, COUNT(*) AS order_count
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_name
HAVING COUNT(*) = (
  SELECT MAX(cnt) FROM (
    SELECT COUNT(*) AS cnt FROM transactions t2
    JOIN products p2 ON t2.product_id = p2.product_id
    GROUP BY p2.product_name
  )
)
ORDER BY p.product_name
