-- ======================================================================
-- The Lion's Share
-- ======================================================================
-- Difficulty : Medium
-- Company    : Allstate
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-lions-share-revenue-concentration
-- ======================================================================

/*
The merchandising finance team suspects our revenue is far more concentrated than the catalog's breadth suggests: a handful of product categories may be quietly carrying the whole business while the rest contribute noise. To make the next planning cycle's investment case, they want a clear picture of how purchase revenue is distributed across product categories. For each category, show how much total purchase revenue it brought in, how many purchases it took to get there, and what portion of the company's overall revenue that category represents, presented from the biggest earner down to the smallest so the concentration is obvious at a glance.

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

Expected output ['category', 'total_revenue', 'transaction_count', 'revenue_share_pct']:
  ['Electronics', 15016.8, 20, 12.06]
  ['Books', 12275.88, 18, 9.86]
  ['Clothing', 12248.94, 18, 9.84]
  ['Home & Kitchen', 12222, 18, 9.81]
  ['Sports', 12195.06, 18, 9.79]
*/


-- Write your SQL solution below:

SELECT p.category AS category, SUM(t.total_amount) AS total_revenue, COUNT(*) AS transaction_count, ROUND(SUM(t.total_amount) * 100.0 / SUM(SUM(t.total_amount)) OVER (), 2) AS revenue_share_pct FROM transactions t JOIN products p ON t.product_id = p.product_id GROUP BY p.category ORDER BY total_revenue DESC, category ASC;
