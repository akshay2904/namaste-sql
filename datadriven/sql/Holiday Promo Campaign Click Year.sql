-- ======================================================================
-- Holiday Promo Campaign Click Year
-- ======================================================================
-- Difficulty : Easy
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/holiday_promo_campaign_click_year
-- ======================================================================

/*
The ad impressions table logs campaign-level clicks. Find the year in which the HOLIDAY_PROMO campaign had at least 1 total click. Roll up impressions by year for the HOLIDAY_PROMO campaign only. Return the qualifying fiscal year.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['fiscal_year']:
  ['2026']
*/


-- Write your SQL solution below:

SELECT strftime('%Y', impression_time) AS fiscal_year
FROM ad_impressions
WHERE ad_campaign = 'HOLIDAY_PROMO'
GROUP BY strftime('%Y', impression_time)
HAVING SUM(clicked) >= 1
