-- ======================================================================
-- Who We Reached
-- ======================================================================
-- Difficulty : Easy
-- Company    : Natera
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_unique_users_per_campaign
-- ======================================================================

/*
The growth team is tracking how each ad campaign's reach moves month over month, where every impression falls within a single year. For each campaign and calendar month, find how many different users saw an impression, sorted by campaign and then by month.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'month', 'unique_users']:
  ['BRAND_AWARENESS_Q1', 1, 2]
  ['BRAND_AWARENESS_Q1', 2, 5]
  ['BRAND_AWARENESS_Q1', 5, 1]
  ['BRAND_AWARENESS_Q1', 6, 4]
  ['HOLIDAY_PROMO', 1, 0]
*/


-- Write your SQL solution below:

SELECT ad_campaign,
    CAST(STRFTIME('%m', impression_time) AS INTEGER) AS month,
    COUNT(DISTINCT user_id) AS unique_users
FROM ad_impressions
GROUP BY ad_campaign, CAST(STRFTIME('%m', impression_time) AS INTEGER)
ORDER BY ad_campaign, month
