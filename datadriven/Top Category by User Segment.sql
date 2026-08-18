-- ======================================================================
-- Top Category by User Segment
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_category_by_user_segment
-- ======================================================================

/*
For every account status, find the product category with the highest number of purchases. If multiple categories are tied within a segment, include all of them. Show the account status, category, and purchase count, sequenced by account status and category.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

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

Expected output ['account_status', 'category', 'purchase_count']:
  ['active', 'Automotive', 8]
  ['inactive', 'Garden', 8]
  ['inactive', 'Sports', 8]
  ['pending_verification', 'Clothing', 8]
  ['suspended', 'Books', 8]
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT
    u.account_status,
    p.category,
    COUNT(*) AS purchase_count,
    RANK() OVER (
      PARTITION BY u.account_status
      ORDER BY COUNT(*) DESC
    ) AS rk
  FROM transactions t
  JOIN users u    ON t.user_id    = u.user_id
  JOIN products p ON t.product_id = p.product_id
  GROUP BY u.account_status, p.category
)
SELECT account_status, category, purchase_count
FROM ranked
WHERE rk = 1
ORDER BY account_status, category;
