-- ======================================================================
-- Top Product Category by Transactions
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_product_category_by_transactions
-- ======================================================================

/*
Which product category had the highest transaction volume in 2026? Return the category name and transaction count. If there's a tie, include all tied categories.

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

Expected output ['category', 'transaction_count']:
  ['Electronics', 20]
*/


-- Write your SQL solution below:

SELECT p.category,
       COUNT(*) AS transaction_count
FROM transactions t
JOIN products p ON t.product_id = p.product_id
WHERE strftime('%Y', t.transaction_date) = '2026'
GROUP BY p.category
HAVING COUNT(*) = (
  SELECT MAX(cnt) FROM (
    SELECT COUNT(*) AS cnt
    FROM transactions t2
    JOIN products p2 ON t2.product_id = p2.product_id
    WHERE strftime('%Y', t2.transaction_date) = '2026'
    GROUP BY p2.category
  )
)
ORDER BY p.category;
