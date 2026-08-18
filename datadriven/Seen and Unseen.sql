-- ======================================================================
-- Seen and Unseen
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/notification_open_rate
-- ======================================================================

/*
The engagement team wants to know which platforms actually get push notifications read. For each platform, give the open rate as a percentage of notifications sent, highest first.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['platform', 'open_rate_pct']:
  ['ios', 33.333333333333336]
  ['android', 30.76923076923077]
  ['iOS', 30.76923076923077]
  ['WEB', 25]
  ['Android', 23.076923076923077]
*/


-- Write your SQL solution below:

SELECT platform,
       SUM(opened) * 100.0 / COUNT(*) AS open_rate_pct
FROM push_notifs
GROUP BY platform
ORDER BY open_rate_pct DESC, platform
