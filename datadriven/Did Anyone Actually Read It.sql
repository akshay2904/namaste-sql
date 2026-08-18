-- ======================================================================
-- Did Anyone Actually Read It?
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/notifications_opened_on_date
-- ======================================================================

/*
Growth wants to know which platforms actually drive push engagement in 2026. A notification counts as a real win only when it reached the device (status = 'delivered', though the data is careless about capitalization) and the user opened it (opened = 1). For each platform, return the count of these wins as opened_count, from the most to the fewest.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['platform', 'opened_count']:
  ['ios', 4]
  ['android', 3]
  ['basic', 3]
  ['web', 3]
*/


-- Write your SQL solution below:

SELECT LOWER(platform) AS platform,
       COUNT(*) AS opened_count
FROM push_notifs
WHERE opened = 1
  AND LOWER(status) = 'delivered'
  AND strftime('%Y', sent_at) = '2026'
GROUP BY LOWER(platform)
ORDER BY opened_count DESC, platform ASC
