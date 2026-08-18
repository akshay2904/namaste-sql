-- ======================================================================
-- The Open Question
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/push_notification_open_rate
-- ======================================================================

/*
A product team wants the daily open rate for its push notifications: of the notifications sent on a given day, what share were opened (`opened` is 1). Report that rate for each send date, and include only the dates where at least one notification was opened.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['send_date', 'open_rate']:
  ['2022-03-24', 1]
  ['2022-06-07', 1]
  ['2022-06-11', 1]
  ['2026-04-16', 0.5]
  ['2026-07-07', 0.5]
*/


-- Write your SQL solution below:

SELECT
    DATE(sent_at) AS send_date,
    SUM(opened) * 1.0 / COUNT(*) AS open_rate
FROM push_notifs
GROUP BY DATE(sent_at)
HAVING SUM(opened) > 0
