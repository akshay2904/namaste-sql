-- ======================================================================
-- Active User Open Rate
-- ======================================================================
-- Difficulty : Medium
-- Company    : Rockerbox
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/active_user_open_rate
-- ======================================================================

/*
The engagement team is measuring notification effectiveness for the quarterly product review. Compute the percentage of all push notifications that were both sent to a user with an active account and opened by the recipient. Notifications should still be counted in the denominator even if the user's account record no longer exists.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['active_opened_pct']:
  [7]
*/


-- Write your SQL solution below:

SELECT CAST(SUM(CASE WHEN u.account_status = 'active' AND pn.opened = 1 THEN 1 ELSE 0 END) AS REAL) * 100.0 / COUNT(*) AS active_opened_pct
FROM push_notifs pn
LEFT JOIN users u ON pn.user_id = u.user_id
