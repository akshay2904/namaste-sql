-- ======================================================================
-- Tiers of Want
-- ======================================================================
-- Difficulty : Hard
-- Company    : HealthTap
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/user_spend_segmentation_by_category
-- ======================================================================

/*
A retail marketplace wants to see how its shoppers stack up inside each product category, scoring every shopper on their average basket size (total spend divided by number of purchases) in that category. Sort each shopper into a spend tier: High above $500, Medium from $200 up to $500, and Low below that. For each category and tier, report how many shoppers land there along with their combined transactions, combined sales, and the average basket size across them.

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

Expected output ['category', 'segment', 'unique_users', 'total_transactions', 'total_sales', 'avg_basket_size']:
  ['Automotive', 'High', 2, 14, 10350.119999999999, 744.105]
  ['Automotive', 'Medium', 1, 4, 1764.1200000000001, 441.03000000000003]
  ['Beauty', 'High', 3, 18, 12141.18, 674.51]
  ['Books', 'High', 3, 18, 12275.880000000001, 696.96]
  ['Clothing', 'High', 3, 18, 12248.94, 710.43]
*/


-- Write your SQL solution below:

WITH user_baskets AS (
    SELECT
        t.user_id,
        p.category,
        SUM(t.total_amount) AS total_sales,
        COUNT(*) AS txn_count,
        SUM(t.total_amount) * 1.0 / COUNT(*) AS basket_size,
        CASE
            WHEN SUM(t.total_amount) * 1.0 / COUNT(*) > 500 THEN 'High'
            WHEN SUM(t.total_amount) * 1.0 / COUNT(*) >= 200 THEN 'Medium'
            ELSE 'Low'
        END AS segment
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id
    GROUP BY t.user_id, p.category
)
SELECT
    category,
    segment,
    COUNT(*) AS unique_users,
    SUM(txn_count) AS total_transactions,
    SUM(total_sales) AS total_sales,
    AVG(basket_size) AS avg_basket_size
FROM user_baskets
GROUP BY category, segment
