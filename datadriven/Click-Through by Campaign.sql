-- ======================================================================
-- Click-Through by Campaign
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaign_revenue_by_click_channel
-- ======================================================================

/*
The ad team wants an engagement breakdown by campaign. For each campaign, show the total number of impressions and the percentage that were clicked versus not clicked. List alphabetically by campaign.

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

Expected output ['ad_campaign', 'total_impressions', 'clicked_pct', 'not_clicked_pct']:
  ['BRAND_AWARENESS_Q1', 18, 16.67, 83.33]
  ['FLASH_SALE_48H', 16, 25, 75]
  ['HOLIDAY_PROMO', 17, 23.53, 76.47]
  ['LOYALTY_PROGRAM', 76, 82.89, 17.11]
  ['SUMMER_SALE_2024', 22, 31.82, 68.18]
*/


-- Write your SQL solution below:

SELECT ad_campaign, COUNT(*) AS total_impressions, ROUND(CAST(SUM(CASE WHEN clicked=1 THEN 1 ELSE 0 END) AS REAL)*100.0/COUNT(*),2) AS clicked_pct, ROUND(CAST(SUM(CASE WHEN clicked=0 THEN 1 ELSE 0 END) AS REAL)*100.0/COUNT(*),2) AS not_clicked_pct FROM ad_impressions GROUP BY ad_campaign ORDER BY ad_campaign
