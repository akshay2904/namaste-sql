-- ======================================================================
-- The Three-Way Report
-- ======================================================================
-- Difficulty : Medium
-- Company    : Citizens
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/multi_table_report
-- ======================================================================

/*
Combine session engagement with transaction revenue into a single user report. For each user, show their name, total session count, and total transaction amount. Users with zero sessions or zero transactions must still appear; the report cannot silently drop inactive users.

Table: users(user_id, username)

Table: user_sessions(session_id, user_id)

Table: transactions(transaction_id, user_id, total_amount)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['username', 'session_count', 'total_amount']:
  ['alice', 8, 8605.98]
  ['aaron42', 5, 8814.54]
  ['amelia', 5, 9003.12]
  ['arjun', 5, 9191.7]
  ['ava99', 5, 9380.28]
*/


-- Write your SQL solution below:

WITH session_agg AS (
    SELECT user_id, COUNT(*) AS session_count
    FROM user_sessions
    GROUP BY user_id
),
txn_agg AS (
    SELECT user_id, SUM(total_amount) AS total_amount
    FROM transactions
    GROUP BY user_id
)
SELECT
    u.username,
    COALESCE(sa.session_count, 0) AS session_count,
    COALESCE(ta.total_amount, 0) AS total_amount
FROM users u
LEFT JOIN session_agg sa ON u.user_id = sa.user_id
LEFT JOIN txn_agg ta ON u.user_id = ta.user_id
