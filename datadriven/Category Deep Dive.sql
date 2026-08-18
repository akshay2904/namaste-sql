-- ======================================================================
-- Category Deep Dive
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/category_deep_dive
-- ======================================================================

/*
Strategy wants a full financial picture per product category. For each category, compute total revenue (sum of transaction amounts) and total units sold (sum of quantities). Assign each category a position by revenue, highest first, with ties sharing a position. Return the category, revenue, units, and position.

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

Expected output ['category', 'total_revenue', 'total_units', 'position']:
  ['Electronics', 15016.8, 20, 1]
  ['Books', 12275.88, 36, 2]
  ['Clothing', 12248.94, 54, 3]
  ['Home & Kitchen', 12222, 72, 4]
  ['Sports', 12195.06, 90, 5]
*/


-- Write your SQL solution below:

SELECT
    p.category,
    SUM(t.total_amount) AS total_revenue,
    SUM(t.quantity) AS total_units,
    RANK() OVER (ORDER BY SUM(t.total_amount) DESC) AS position
FROM products p
JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.category
