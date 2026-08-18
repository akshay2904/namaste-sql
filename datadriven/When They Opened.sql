-- ======================================================================
-- When They Opened
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/opened_notifications_in_jan_feb
-- ======================================================================

/*
The marketing team wants a month-by-month read on push engagement across the year. For each month, find how many notifications were opened, busiest month first.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['month', 'opened_count']:
  [1, 7]
  [3, 7]
  [4, 7]
  [6, 6]
  [7, 6]
*/


-- Write your SQL solution below:

SELECT CAST(strftime('%m', sent_at) AS INTEGER) AS month,
       COUNT(*) AS opened_count
FROM push_notifs
WHERE opened = 1
GROUP BY month
ORDER BY opened_count DESC, month
