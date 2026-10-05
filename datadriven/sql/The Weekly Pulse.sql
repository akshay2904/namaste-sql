-- ======================================================================
-- The Weekly Pulse
-- ======================================================================
-- Difficulty : Medium
-- Company    : Zenefits
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/notifications_pivot_by_weekday
-- ======================================================================

/*
Build a notification volume breakdown pivoted by platform and day of week, scoped to users enrolled in at least one experiment. Rows should be days of the week (0=Sunday through 6=Saturday), with separate count columns for ios, android, and web. Return the day of week and each platform's count.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Expected output ['day_of_week', 'ios_count', 'android_count', 'web_count']:
  [0, 8, 7, 9]
  [1, 5, 9, 5]
  [2, 10, 6, 8]
  [3, 6, 7, 6]
  [4, 5, 8, 7]
*/


-- Write your SQL solution below:

SELECT
    CAST(strftime('%w', pn.sent_at) AS INTEGER) AS day_of_week,
    SUM(CASE WHEN LOWER(pn.platform) = 'ios'     THEN 1 ELSE 0 END) AS ios_count,
    SUM(CASE WHEN LOWER(pn.platform) = 'android' THEN 1 ELSE 0 END) AS android_count,
    SUM(CASE WHEN LOWER(pn.platform) = 'web'     THEN 1 ELSE 0 END) AS web_count
FROM push_notifs pn
WHERE pn.user_id IN (SELECT DISTINCT user_id FROM experiments)
GROUP BY CAST(strftime('%w', pn.sent_at) AS INTEGER)
ORDER BY day_of_week
