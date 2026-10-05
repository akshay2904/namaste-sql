-- ======================================================================
-- Click Revenue
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/click_revenue
-- ======================================================================

/*
The ad operations team is evaluating campaign ROI for the monthly review. For each ad campaign, calculate the total revenue generated exclusively from impressions that resulted in a click. Only include campaigns that brought in more than five dollars in click revenue, and rank them from highest total to lowest.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'click_revenue']:
  ['LOYALTY_PROGRAM', 191.55]
  ['SUMMER_SALE_2024', 16.7]
  ['HOLIDAY_PROMO', 6.2]
  ['FLASH_SALE_48H', 5.6]
*/


-- Write your SQL solution below:

SELECT ad_campaign, SUM(revenue) AS click_revenue
FROM ad_impressions
WHERE clicked = 1
GROUP BY ad_campaign
HAVING SUM(revenue) > 5
ORDER BY click_revenue DESC
