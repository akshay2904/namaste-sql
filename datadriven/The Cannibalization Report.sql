-- ======================================================================
-- The Cannibalization Report
-- ======================================================================
-- Difficulty : Hard
-- Company    : Thumbtack
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_cannibalization_report
-- ======================================================================

/*
For each product whose first transaction occurred in the last 6 months, compare the category's total sales in the 30 days before that product's first sale versus 30 days after. Show the product name, category, pre-entry sales, post-entry sales, and the percentage change.

Table: products(product_id, product_name, category, price)

Table: transactions(transaction_id, product_id, total_amount, transaction_date)

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

Expected output ['product_name', 'category', 'pre_entry_sales', 'post_entry_sales', 'pct_change']:
  ['Premium Widget 80X', 'Electronics', 279.39, 1366.98, 389.27]
  ['Essential Set 35X', 'Toys', 616.14, 1771.08, 187.45]
  ['Essential Set 95X', 'Toys', 1097.58, 1771.08, 61.36]
  ['Premium Widget 10X', 'Electronics', 1366.98, 1097.58, -19.71]
  ['Premium Widget 70X', 'Electronics', 1511.67, 1097.58, -27.39]
*/


-- Write your SQL solution below:

$1a
