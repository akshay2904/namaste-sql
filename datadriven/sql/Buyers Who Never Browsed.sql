-- ======================================================================
-- Buyers Who Never Browsed
-- ======================================================================
-- Difficulty : Easy
-- Company    : Fidelity Investments
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unmatched_credit_complaints
-- ======================================================================

/*
The fraud team flagged a batch of purchases made by users who have never browsed the site. Find every transaction from 2026 where the buyer has no record in page_views at all. Return each user's username and the transaction total, smallest amount first.

Table: users(user_id, username)

Table: transactions(transaction_id, user_id, total_amount, transaction_date)

Table: page_views(view_id, user_id, viewed_at)

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

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['username', 'total_amount']:
  ['arjun', 50.4]
  ['aiden', 104.28]
  ['beatrice', 158.16]
  ['arjun', 252.45]
  ['aiden', 306.33]
*/


-- Write your SQL solution below:

SELECT u.username, t.total_amount
FROM transactions t
JOIN users u ON t.user_id = u.user_id
WHERE strftime('%Y', t.transaction_date) = '2026'
  AND NOT EXISTS (
        SELECT 1 FROM page_views pv WHERE pv.user_id = t.user_id
      )
ORDER BY t.total_amount, u.username;
