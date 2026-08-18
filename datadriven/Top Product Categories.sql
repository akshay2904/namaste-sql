-- ======================================================================
-- Top Product Categories
-- ======================================================================
-- Difficulty : Medium
-- Company    : Spark
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_product_categories
-- ======================================================================

/*
Find the top 3 product categories by total transactions. If categories are tied at a cutoff rank, include all of them. Category info comes from the products table. Return the category, transaction count, and rank.

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

Expected output ['category', 'txn_count', 'rnk']:
  ['Electronics', 20, 1]
  ['Automotive', 18, 2]
  ['Beauty', 18, 2]
  ['Books', 18, 2]
  ['Clothing', 18, 2]
*/


-- Write your SQL solution below:

SELECT category, txn_count, rnk
FROM (
  SELECT
    p.category AS category,
    COUNT(*) AS txn_count,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
  FROM transactions t
  JOIN products p ON t.product_id = p.product_id
  GROUP BY p.category
) ranked
WHERE rnk <= 3
ORDER BY rnk, txn_count DESC, category;
