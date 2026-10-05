-- ======================================================================
-- Top 2 Active Push Days
-- ======================================================================
-- Difficulty : Medium
-- Company    : Walmart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_2_active_push_days
-- ======================================================================

/*
During a push notification window from August 1 to 7, which two days saw the most unique users receiving a notification? Show the day of week number (0=Sunday through 6=Saturday), date, and unique user count.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['day_name', 'send_date', 'unique_users']:
  ['2', '2026-08-04', 1]
*/


-- Write your SQL solution below:

SELECT TRIM(strftime('%w', sent_at)) AS day_name,
       DATE(sent_at)                  AS send_date,
       COUNT(DISTINCT user_id)        AS unique_users
FROM push_notifs
WHERE DATE(sent_at) BETWEEN '2026-08-01' AND '2026-08-07'
GROUP BY send_date
ORDER BY unique_users DESC
LIMIT 2
