-- ======================================================================
-- The Heaviest Hitters
-- ======================================================================
-- Difficulty : Easy
-- Company    : Apple
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_ad_revenue_moment
-- ======================================================================

/*
The ad ops team is auditing which impressions pulled in the most money. Surface the three highest-revenue impressions, each with when it occurred and the revenue it earned, biggest earner first.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['impression_time', 'revenue']:
  ['2026-12-15 12:00:00', 4.5]
  ['2025-12-15 12:00:00', 4.5]
  ['2024-12-15 12:00:00', 4.5]
*/


-- Write your SQL solution below:

SELECT impression_time, revenue
FROM ad_impressions
ORDER BY revenue DESC
LIMIT 3
