-- ======================================================================
-- Category Sales Summary
-- ======================================================================
-- Difficulty : Easy
-- Company    : Workday
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/category_sales_summary
-- ======================================================================

/*
The merchandising team needs a 2026 sales overview by product category. For each category with at least one sale, show the number of unique transactions and total revenue, sorted from highest revenue to lowest.

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

Expected output ['category', 'unique_transactions', 'total_revenue']:
  ['Electronics', 20, 15016.8]
  ['Toys', 18, 12168.12]
  ['Books', 9, 6137.94]
  ['Clothing', 9, 6124.47]
  ['Home & Kitchen', 9, 6111]
*/


-- Write your SQL solution below:

SELECT
    p.category,
    COUNT(DISTINCT t.transaction_id) AS unique_transactions,
    SUM(t.total_amount) AS total_revenue
FROM transactions t
JOIN products p ON t.product_id = p.product_id
WHERE t.transaction_date >= '2026-01-01'
  AND t.transaction_date < '2027-01-01'
GROUP BY p.category
ORDER BY total_revenue DESC
