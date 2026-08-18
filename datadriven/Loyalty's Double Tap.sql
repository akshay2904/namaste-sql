-- ======================================================================
-- Loyalty's Double Tap
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/clicked_holiday_impressions
-- ======================================================================

/*
Growth wants to know whether push notifications and display ads reinforce each other. Count the clicked ad impressions belonging to users who were also part of a loyalty push-notification campaign (any campaign whose name contains 'loyalty', case-insensitive). Join ad_impressions to push_notifs on user_id, keep only clicked impressions, and return the total count as impression_count.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['impression_count']:
  [38]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS impression_count
FROM ad_impressions ai
INNER JOIN push_notifs pn ON ai.user_id = pn.user_id
WHERE ai.clicked = 1 AND LOWER(pn.campaign) LIKE '%loyalty%'
