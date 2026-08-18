-- ======================================================================
-- Targeted Ad Campaigns
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/targeted_ad_campaigns
-- ======================================================================

/*
The ad ops team is auditing click-through data for two specific campaigns. Pull all impression records from 'RETARGETING_CART' or 'BRAND_AWARENESS_Q1' where the user actually clicked.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [1525, 488, 'BRAND_AWARENESS_Q1', '2026-02-26 01:55:00', 1, 0.8]
  [2055, 488, 'RETARGETING_CART', '2026-12-08 11:05:00', 1, 1.1]
  [3645, 488, 'BRAND_AWARENESS_Q1', '2026-06-10 17:35:00', 1, 2]
  [4175, 488, 'RETARGETING_CART', '2026-04-20 03:45:00', 1, 2.3]
  [10009023, 488, 'BRAND_AWARENESS_Q1', '2026-01-26 01:55:00', 1, 0.8]
*/


-- Write your SQL solution below:

SELECT *
FROM ad_impressions
WHERE ad_campaign IN ('RETARGETING_CART', 'BRAND_AWARENESS_Q1') AND clicked = 1
