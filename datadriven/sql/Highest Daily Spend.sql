-- ======================================================================
-- Highest Daily Spend
-- ======================================================================
-- Difficulty : Medium
-- Company    : Shopify
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/highest_daily_spend
-- ======================================================================

/*
Between March 1 and June 1, 2026, find the users with the highest daily spending. If a user placed multiple orders on the same day, sum those amounts. If multiple users tie for the highest daily total on a given date, return all of them. Every username is unique.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

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

Expected output ['username', 'total_daily_spend', 'transaction_date']:
  ['beatrice', 1168.41, '2026-03-03']
  ['amelia', 845.13, '2026-03-07']
  ['aria_b', 521.85, '2026-03-11']
  ['aria_b', 1330.05, '2026-03-15']
  ['alice', 212.04, '2026-03-16']
*/


-- Write your SQL solution below:

WITH daily_spend AS (
    SELECT u.username,
           t.transaction_date,
           SUM(t.total_amount) AS total_daily_spend
    FROM users u
    INNER JOIN transactions t ON u.user_id = t.user_id
    WHERE t.transaction_date BETWEEN '2026-03-01' AND '2026-06-01'
    GROUP BY u.username, t.transaction_date
),
ranked AS (
    SELECT username,
           total_daily_spend,
           transaction_date,
           DENSE_RANK() OVER (PARTITION BY transaction_date ORDER BY total_daily_spend DESC) AS rnk
    FROM daily_spend
)
SELECT username, total_daily_spend, transaction_date
FROM ranked
WHERE rnk = 1
ORDER BY transaction_date, username
