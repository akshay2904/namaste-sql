-- ======================================================================
-- Top Campaign by User Revenue
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_campaign_by_user_revenue
-- ======================================================================

/*
For each user who clicked an ad, find which campaign generated the most revenue for that user. If multiple campaigns tie for the top, list each qualifying entry only once. Show the user and the top campaign.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['user_id', 'ad_campaign']:
  [None, 'PRODUCT_LAUNCH_X']
  [488, 'FLASH_SALE_48H']
  [973, 'HOLIDAY_PROMO']
  [2137, 'LOYALTY_PROGRAM']
  [3301, 'SUMMER_SALE_2024']
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT user_id, ad_campaign,
         DENSE_RANK() OVER (PARTITION BY user_id ORDER BY revenue DESC) AS rnk
  FROM ad_impressions
  WHERE clicked = 1
)
SELECT DISTINCT r.user_id, r.ad_campaign
FROM ranked r
WHERE r.rnk = 1
