-- ======================================================================
-- Ad Revenue 2026
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/ad_revenue
-- ======================================================================

/*
The ad sales team is closing out the books on 2026 and needs the annual numbers by campaign. Total the revenue each campaign brought in, biggest earners first.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'total_revenue']:
  ['LOYALTY_PROGRAM', 41.55]
  ['SUMMER_SALE_2024', 16.7]
  ['HOLIDAY_PROMO', 6.2]
  ['FLASH_SALE_48H', 5.6]
  ['PRODUCT_LAUNCH_X', 5]
*/


-- Write your SQL solution below:

SELECT
  ad_campaign,
  SUM(revenue) AS total_revenue
FROM ad_impressions
WHERE strftime('%Y', impression_time) = '2026'
GROUP BY ad_campaign
ORDER BY total_revenue DESC
