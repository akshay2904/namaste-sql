-- ======================================================================
-- Campaign Cost Effectiveness
-- ======================================================================
-- Difficulty : Medium
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaign_cost_effectiveness
-- ======================================================================

/*
The marketing team is evaluating return on ad spend and needs a cost-effectiveness metric for each campaign between 2025 and 2026 inclusive. Show each campaign alongside the ratio of total revenue to total clicks.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'revenue_per_click']:
  ['LOYALTY_PROGRAM', 2.9277777777777776]
  ['SUMMER_SALE_2024', 2.3857142857142857]
  ['RETARGETING_CART', 1.7]
  ['HOLIDAY_PROMO', 1.55]
  ['FLASH_SALE_48H', 1.4]
*/


-- Write your SQL solution below:

SELECT
    ad_campaign,
    SUM(revenue) * 1.0 / NULLIF(SUM(clicked), 0) AS revenue_per_click
FROM ad_impressions
WHERE CAST(strftime('%Y', impression_time) AS INTEGER)
      BETWEEN 2026 - 1 AND 2026
GROUP BY ad_campaign
ORDER BY revenue_per_click DESC, ad_campaign ASC
