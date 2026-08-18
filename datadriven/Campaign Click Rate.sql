-- ======================================================================
-- Campaign Click Rate
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/daily_spam_impression_rate
-- ======================================================================

/*
Limit to users who also appear in page_views. For each ad campaign, compute the percentage of that campaign's impressions which were clicked. Show the campaign and clicked percentage, highest first.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['ad_campaign', 'clicked_pct']:
  ['HOLIDAY_PROMO', 50]
  ['PRODUCT_LAUNCH_X', 37.5]
  ['SUMMER_SALE_2024', 28.57]
  ['FLASH_SALE_48H', 25]
  ['NEW_USER_ACQU', 25]
*/


-- Write your SQL solution below:

SELECT ai.ad_campaign, ROUND(CAST(SUM(CASE WHEN ai.clicked=1 THEN 1 ELSE 0 END) AS REAL)*100.0/COUNT(*),2) AS clicked_pct FROM ad_impressions ai WHERE ai.user_id IN (SELECT user_id FROM page_views) GROUP BY ai.ad_campaign ORDER BY clicked_pct DESC, ai.ad_campaign
