-- ======================================================================
-- The Price of a Tap
-- ======================================================================
-- Difficulty : Easy
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/promo_campaign_cost_per_acquisition
-- ======================================================================

/*
Marketing has been running promotional push campaigns whose names all contain 'promo', and wants to know how hard each one worked to earn a customer. For every promo campaign, broken out by year, find how many notifications it took to earn a single open: total notifications sent divided by the number that were opened.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['campaign', 'year', 'cost_per_acquisition']:
  ['promo_summer', '2023', 3.3333333333333335]
  ['promo_summer', '2026', 3.3333333333333335]
*/


-- Write your SQL solution below:

SELECT
    campaign,
    strftime('%Y', sent_at) AS year,
    COUNT(*) * 1.0 / SUM(opened) AS cost_per_acquisition
FROM push_notifs
WHERE campaign LIKE '%promo%'
  AND opened IS NOT NULL
GROUP BY campaign, strftime('%Y', sent_at)
HAVING SUM(opened) > 0
