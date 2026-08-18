-- ======================================================================
-- The Phantom Readers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Merilytics
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_phantom_readers
-- ======================================================================

/*
The growth team wants to target window shoppers with a promotion. Find users who viewed at least 5 pages in the past 30 days but have zero transactions ever. Return their user_id, username, email, and total view count, sorted from most views to least.

Table: users(user_id, username, email, signup_date)

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'username', 'email', 'total_views']:
  [1555, 'brooke7', 'brooke7@example.com', 10]
  [1652, 'carlos', 'carlos@example.com', 10]
  [1749, 'chloe', 'chloe@example.com', 10]
  [1846, 'cameron', 'cameron@example.com', 10]
  [1943, 'cyrus', 'cyrus@example.com', 10]
*/


-- Write your SQL solution below:

SELECT
    u.user_id,
    u.username,
    u.email,
    COUNT(*) AS total_views
FROM users u
INNER JOIN page_views av ON u.user_id = av.user_id
LEFT JOIN transactions p ON u.user_id = p.user_id
WHERE av.viewed_at >= date('now', '-30 days')
  AND p.transaction_id IS NULL
GROUP BY u.user_id, u.username, u.email
HAVING COUNT(*) >= 5
ORDER BY total_views DESC;
