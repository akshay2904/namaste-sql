-- ======================================================================
-- Clicked Ad Impressions
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/clicked_ad_impressions
-- ======================================================================

/*
The ad analytics team needs the raw data behind every clicked impression for a detailed review. Pull all fields from ad impression records where the user clicked.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]
  [730, 973, 'PRODUCT_LAUNCH_X', '2026-11-11 10:10:00', 1, 0.35]
  [995, 488, 'FLASH_SALE_48H', '2026-04-16 15:45:00', 1, 0.5]
  [1260, 973, 'HOLIDAY_PROMO', '2026-09-21 20:20:00', 1, 0.65]
  [1525, 488, 'BRAND_AWARENESS_Q1', '2026-02-26 01:55:00', 1, 0.8]
*/


-- Write your SQL solution below:

SELECT *
FROM ad_impressions
WHERE clicked = 1
