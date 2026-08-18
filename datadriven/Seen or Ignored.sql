-- ======================================================================
-- Seen or Ignored
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/notification_delivery_ratio
-- ======================================================================

/*
Our push notification system logs every send along with whether the recipient opened it. Find each platform's fraction of sent notifications that were opened, strongest open rate first.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['platform', 'open_ratio']:
  ['ios', 0.3333333333333333]
  ['iOS', 0.3076923076923077]
  ['android', 0.3076923076923077]
  ['premium', 0.25]
  ['web', 0.23076923076923078]
*/


-- Write your SQL solution below:

SELECT platform,
       SUM(opened) * 1.0 / COUNT(*) AS open_ratio
FROM push_notifs
GROUP BY platform
ORDER BY open_ratio DESC
