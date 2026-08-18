-- ======================================================================
-- Retargeting Campaign Impressions
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/retargeting_campaign_impressions
-- ======================================================================

/*
There's a discrepancy in ad impression numbers. Pull all available fields for campaigns whose name contains 'retarget' so we can verify what's flowing into the retargeting segment.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [783, 100, 'RETARGETING_CART', '2026-12-12 11:17:00', 0, None]
  [1207, 876, 'RETARGETING_CART', '2026-08-20 19:13:00', 0, None]
  [1631, 682, 'RETARGETING_CART', '2026-04-28 03:09:00', 0, None]
  [2055, 488, 'RETARGETING_CART', '2026-12-08 11:05:00', 1, 1.1]
*/


-- Write your SQL solution below:

SELECT *
FROM ad_impressions
WHERE ad_campaign LIKE '%retarget%'
