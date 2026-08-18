-- ======================================================================
-- The Ad Ledger
-- ======================================================================
-- Difficulty : Easy
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_ad_ledger
-- ======================================================================

/*
The finance team needs the total ad impression revenue for 2026 to close out the annual report. Return a single total.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['total_revenue']:
  [86.45]
*/


-- Write your SQL solution below:

SELECT SUM(revenue) AS total_revenue
FROM ad_impressions
WHERE impression_time >= '2026-01-01'
  AND impression_time < '2027-01-01'
