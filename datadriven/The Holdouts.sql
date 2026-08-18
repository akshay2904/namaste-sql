-- ======================================================================
-- The Holdouts
-- ======================================================================
-- Difficulty : Medium
-- Company    : Infosys
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/subscribers_without_premium
-- ======================================================================

/*
In our push-notification log, each message records the plan tier it targeted in the `platform` field. Find the unique users who were sent a `basic`-tier notification but never a `premium`-tier one.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['user_id']:
  [585]
  [1361]
  [2137]
  [2913]
  [3689]
*/


-- Write your SQL solution below:

SELECT DISTINCT user_id
FROM push_notifs
WHERE platform = 'basic' AND user_id NOT IN (SELECT user_id FROM push_notifs WHERE platform = 'premium')
