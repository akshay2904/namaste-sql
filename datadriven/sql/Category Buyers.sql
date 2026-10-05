-- ======================================================================
-- Category Buyers
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/category_buyers
-- ======================================================================

/*
The merchandising team is deciding how to concentrate their next promotional push. For each product category, they need to know how many unique customers made a purchase and how much revenue those purchases generated in total. Only include categories that have attracted at least three unique buyers ,  niche categories with a smaller audience aren't in scope. Rank from the most revenue to the least.

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

Expected output ['category', 'unique_buyers', 'total_revenue']:
  ['Electronics', 3, 15016.8]
  ['Books', 3, 12275.88]
  ['Clothing', 3, 12248.94]
  ['Home & Kitchen', 3, 12222]
  ['Sports', 3, 12195.06]
*/


-- Write your SQL solution below:

SELECT
    p.category,
    COUNT(DISTINCT t.user_id) AS unique_buyers,
    SUM(t.total_amount) AS total_revenue
FROM products p
JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.category
HAVING COUNT(DISTINCT t.user_id) >= 3
ORDER BY total_revenue DESC
