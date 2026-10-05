-- ======================================================================
-- The Dormant Accounts
-- ======================================================================
-- Difficulty : Easy
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_dormant_accounts
-- ======================================================================

/*
Finance is looking at active accounts who haven't shown up in over 90 days, deciding whether to nudge them or shut them down. Surface each one's username, account status, the date of their most recent login, and how much they've spent over their lifetime.

Table: users(user_id, username, account_status)

Table: user_sessions(session_id, user_id, session_start)

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

Expected output ['username', 'account_status', 'last_login', 'lifetime_spend']:
  ['caleb', 'active', '2026-01-05 10:00:00', 0]
  ['divya', 'active', '2026-02-05 10:00:00', 0]
  ['dora_77', 'active', '2026-03-05 10:00:00', 0]
  ['hiro', 'active', '2025-01-06 01:00:00', 0]
  ['ivan', 'active', '2025-01-10 05:00:00', 0]
*/


-- Write your SQL solution below:

SELECT
    u.username,
    u.account_status,
    MAX(s.session_start) AS last_login,
    COALESCE(SUM(t.total_amount), 0) AS lifetime_spend
FROM users u
LEFT JOIN user_sessions s ON u.user_id = s.user_id
LEFT JOIN transactions t ON u.user_id = t.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username, u.account_status
HAVING MAX(s.session_start) < datetime('now', '-90 days')
