-- ======================================================================
-- Active Campaigns
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/active_campaigns
-- ======================================================================

/*
The advertising team is evaluating campaign performance for the quarterly review. For each ad campaign, show the number of impressions served, the total revenue generated, and the click-through rate as a percentage rounded to one decimal place. Only include campaigns with more than five impressions, presented from highest click-through rate to lowest.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'impressions', 'total_revenue', 'ctr']:
  ['LOYALTY_PROGRAM', 76, 191.55, 82.9]
  ['SUMMER_SALE_2024', 22, 16.7, 31.8]
  ['FLASH_SALE_48H', 16, 5.6, 25]
  ['HOLIDAY_PROMO', 17, 6.2, 23.5]
  ['PRODUCT_LAUNCH_X', 18, 5, 22.2]
*/


-- Write your SQL solution below:

SELECT
    ad_campaign,
    COUNT(*) AS impressions,
    SUM(revenue) AS total_revenue,
    ROUND(100.0 * SUM(clicked) / COUNT(*), 1) AS ctr
FROM ad_impressions
GROUP BY ad_campaign
HAVING COUNT(*) > 5
ORDER BY ctr DESC, ad_campaign
