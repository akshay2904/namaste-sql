-- ======================================================================
-- Return on a Glance
-- ======================================================================
-- Difficulty : Easy
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_brand_campaign_revenue
-- ======================================================================

/*
The marketing analytics team is benchmarking how much revenue each ad campaign earns per impression, where every impression served counts toward the average even the ones that brought in nothing. Give each campaign that figure, highest first.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'avg_revenue_per_impression']:
  ['LOYALTY_PROGRAM', 2.5204]
  ['SUMMER_SALE_2024', 0.7591]
  ['HOLIDAY_PROMO', 0.3647]
  ['FLASH_SALE_48H', 0.35]
  ['PRODUCT_LAUNCH_X', 0.2778]
*/


-- Write your SQL solution below:

SELECT ad_campaign,
       ROUND(COALESCE(SUM(revenue), 0) * 1.0 / COUNT(*), 4) AS avg_revenue_per_impression
FROM ad_impressions
GROUP BY ad_campaign
ORDER BY avg_revenue_per_impression DESC, ad_campaign;
