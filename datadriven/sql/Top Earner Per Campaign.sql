-- ======================================================================
-- Top Earner Per Campaign
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_earner_per_campaign
-- ======================================================================

/*
For each campaign, show the top-earning user and their total revenue. Ignore impressions that are not attributed to a user (NULL user_id). If there's a tie, show all tied users.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'user_id', 'total_revenue']:
  ['BRAND_AWARENESS_Q1', 488, 3.6]
  ['FLASH_SALE_48H', 488, 5.6]
  ['HOLIDAY_PROMO', 973, 4.35]
  ['LOYALTY_PROGRAM', 3204, 22.5]
  ['PRODUCT_LAUNCH_X', 973, 2.25]
*/


-- Write your SQL solution below:

SELECT ad_campaign, user_id, total_revenue
FROM (
    SELECT
        ad_campaign,
        user_id,
        SUM(revenue) AS total_revenue,
        RANK() OVER (PARTITION BY ad_campaign ORDER BY SUM(revenue) DESC) AS rnk
    FROM ad_impressions
    WHERE user_id IS NOT NULL
    GROUP BY ad_campaign, user_id
) ranked
WHERE rnk = 1
ORDER BY ad_campaign, user_id
