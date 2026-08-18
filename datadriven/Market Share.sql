-- ======================================================================
-- Market Share
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/market_share
-- ======================================================================

/*
Strategy needs each product category's share of total revenue for the investor deck. For each category, compute its percentage of total transaction revenue against the platform-wide total. Return the category and its revenue share.

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

Expected output ['category', 'revenue_share_pct']:
  ['Electronics', 12.06]
  ['Books', 9.86]
  ['Clothing', 9.84]
  ['Home & Kitchen', 9.81]
  ['Sports', 9.79]
*/


-- Write your SQL solution below:

SELECT p.category,
    ROUND(SUM(CAST(t.total_amount AS DOUBLE)) * 100.0 /
        SUM(SUM(CAST(t.total_amount AS DOUBLE))) OVER (), 2) AS revenue_share_pct
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue_share_pct DESC
