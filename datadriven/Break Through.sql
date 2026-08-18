-- ======================================================================
-- Break Through
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/click_rate
-- ======================================================================

/*
The marketing team is auditing ad campaigns before next quarter's budget is set, and a campaign is only worth renewing when more than one in five impressions turns into a click. Surface those campaigns with their click-through rate and the revenue they brought in, highest click-through rate first.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'ctr_pct', 'total_revenue', 'impressions']:
  ['LOYALTY_PROGRAM', 82.89, 191.55, 76]
  ['SUMMER_SALE_2024', 31.82, 16.7, 22]
  ['FLASH_SALE_48H', 25, 5.6, 16]
  ['HOLIDAY_PROMO', 23.53, 6.2, 17]
  ['PRODUCT_LAUNCH_X', 22.22, 5, 18]
*/


-- Write your SQL solution below:

SELECT
    ad_campaign,
    ROUND(100.0 * SUM(clicked) / COUNT(*), 2) AS ctr_pct,
    SUM(revenue) AS total_revenue,
    COUNT(*) AS impressions
FROM ad_impressions
GROUP BY ad_campaign
HAVING 100.0 * SUM(clicked) / COUNT(*) > 20
ORDER BY ctr_pct DESC, ad_campaign
