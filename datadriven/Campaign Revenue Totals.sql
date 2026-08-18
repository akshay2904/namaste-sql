-- ======================================================================
-- Campaign Revenue Totals
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaign_revenue_totals
-- ======================================================================

/*
The finance team needs campaign-level revenue figures for the annual ad report. Show each campaign and its total revenue.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'total_revenue']:
  ['BRAND_AWARENESS_Q1', 3.6]
  ['FLASH_SALE_48H', 5.6]
  ['HOLIDAY_PROMO', 6.2]
  ['LOYALTY_PROGRAM', 191.55]
  ['NEW_USER_ACQU', 4.4]
*/


-- Write your SQL solution below:

SELECT ad_campaign, SUM(revenue) AS total_revenue
FROM ad_impressions
GROUP BY ad_campaign
