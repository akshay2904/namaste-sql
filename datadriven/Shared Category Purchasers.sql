-- ======================================================================
-- Shared Category Purchasers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/shared_category_purchasers
-- ======================================================================

/*
The recommendations team is building a collaborative filtering feature and needs to identify users with overlapping purchase interests. For each product category, find pairs of users who both purchased in that category, showing the category, both user IDs, and how many products they share, with the highest overlap first.

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

Expected output ['category', 'user1', 'user2', 'shared_categories']:
  ['Automotive', 779, 1264, 48]
  ['Books', 197, 682, 48]
  ['Beauty', 197, 682, 36]
  ['Automotive', 294, 779, 32]
  ['Automotive', 294, 1264, 24]
*/


-- Write your SQL solution below:

SELECT p.category, t1.user_id AS user1, t2.user_id AS user2, COUNT(*) AS shared_categories
FROM transactions t1
INNER JOIN transactions t2 ON t1.user_id < t2.user_id
INNER JOIN products p ON t1.product_id = p.product_id
INNER JOIN products p2 ON t2.product_id = p2.product_id AND p.category = p2.category
GROUP BY p.category, t1.user_id, t2.user_id
ORDER BY shared_categories DESC
