-- ======================================================================
-- Product Ratings vs Sales
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/product_ratings_vs_sales
-- ======================================================================

/*
Strategy wants to know whether higher-rated product categories actually pull more revenue. For each category (excluding products with no rating), compute the average rating and total transaction revenue.

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

Expected output ['category', 'avg_rating', 'total_revenue']:
  ['Automotive', 3.3444444444444446, 12114.24]
  ['Beauty', 3.325, 11420.76]
  ['Books', 3.075, 9804.36]
  ['Clothing', 3.15, 10828.08]
  ['Electronics', 2.5, 15016.8]
*/


-- Write your SQL solution below:

SELECT
    p.category,
    AVG(p.rating) AS avg_rating,
    SUM(t.total_amount) AS total_revenue
FROM products p
JOIN transactions t ON p.product_id = t.product_id
WHERE p.rating IS NOT NULL
GROUP BY p.category
