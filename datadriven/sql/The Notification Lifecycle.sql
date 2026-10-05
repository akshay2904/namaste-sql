-- ======================================================================
-- The Notification Lifecycle
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/push_notification_status_pivot
-- ======================================================================

/*
Our push notification system records a delivery status for every message, but that status is entered inconsistently, so the same outcome shows up in different letter cases. For each registered user, count how many of their notifications were delivered, how many were opened, and how many failed, where an open is captured by its own flag rather than the status text.

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

Expected output ['user_id', 'delivered_count', 'opened_count', 'failed_count']:
  [100, 0, 0, 0]
  [197, 0, 0, 2]
  [294, 0, 2, 0]
  [391, 2, 0, 0]
  [585, 2, 2, 0]
*/


-- Write your SQL solution below:

SELECT
    pn.user_id,
    SUM(CASE WHEN LOWER(pn.status) = 'delivered' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN pn.opened = 1 THEN 1 ELSE 0 END) AS opened_count,
    SUM(CASE WHEN LOWER(pn.status) = 'failed' THEN 1 ELSE 0 END) AS failed_count
FROM push_notifs pn
JOIN users u ON pn.user_id = u.user_id
GROUP BY pn.user_id
