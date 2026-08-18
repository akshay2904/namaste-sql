-- ======================================================================
-- Push Opens by Platform and Campaign
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/push_opens_by_platform_and_campaign
-- ======================================================================

/*
The engagement team suspects iOS users are more responsive to push notifications than Android users. Show how many unique users opened a notification on each platform, sorted from most opens to fewest.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['platform', 'unique_openers']:
  ['ios', 4]
  ['iOS', 4]
  ['android', 4]
  ['web', 3]
  ['premium', 3]
*/


-- Write your SQL solution below:

SELECT platform, COUNT(DISTINCT user_id) AS unique_openers
FROM push_notifs
WHERE opened = 1
GROUP BY platform
ORDER BY unique_openers DESC
