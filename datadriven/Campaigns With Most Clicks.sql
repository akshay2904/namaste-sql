-- ======================================================================
-- Campaigns With Most Clicks
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaigns_with_most_clicks
-- ======================================================================

/*
The ad ops team is identifying which campaigns actually drive engagement. For campaigns that have received at least one click, show the campaign name, total number of clicked impressions, and the highest single-impression revenue, sorted from most clicks to least.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'total_clicks', 'max_impression_revenue']:
  ['LOYALTY_PROGRAM', 63, 4.5]
  ['SUMMER_SALE_2024', 7, 3.2]
  ['PRODUCT_LAUNCH_X', 4, 2.75]
  ['BRAND_AWARENESS_Q1', 3, 2]
  ['RETARGETING_CART', 2, 2.3]
*/


-- Write your SQL solution below:

SELECT
    ad_campaign,
    COUNT(*) AS total_clicks,
    MAX(revenue) AS max_impression_revenue
FROM ad_impressions
WHERE clicked = 1
GROUP BY ad_campaign
ORDER BY total_clicks DESC
