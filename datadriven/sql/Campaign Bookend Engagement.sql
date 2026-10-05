-- ======================================================================
-- Campaign Bookend Engagement
-- ======================================================================
-- Difficulty : Hard
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaign_bookend_engagement
-- ======================================================================

/*
For each ad campaign, what percentage of its total impressions happened on the campaign's very first day versus its very last day?

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'first_day_pct', 'last_day_pct']:
  ['BRAND_AWARENESS_Q1', 5.555555555555555, 5.555555555555555]
  ['FLASH_SALE_48H', 6.25, 6.25]
  ['HOLIDAY_PROMO', 5.882352941176471, 5.882352941176471]
  ['LOYALTY_PROGRAM', 1.3157894736842106, 1.3157894736842106]
  ['SUMMER_SALE_2024', 4.545454545454546, 4.545454545454546]
*/


-- Write your SQL solution below:

WITH campaign_dates AS (
  SELECT ad_campaign,
         MIN(DATE(impression_time)) AS first_day,
         MAX(DATE(impression_time)) AS last_day
  FROM ad_impressions
  GROUP BY ad_campaign
),
campaign_counts AS (
  SELECT ad_campaign, COUNT(*) AS total_impressions
  FROM ad_impressions
  GROUP BY ad_campaign
)
SELECT a.ad_campaign,
       CAST(SUM(CASE WHEN DATE(a.impression_time) = cd.first_day THEN 1 ELSE 0 END) AS REAL)
         * 100.0 / cc.total_impressions AS first_day_pct,
       CAST(SUM(CASE WHEN DATE(a.impression_time) = cd.last_day THEN 1 ELSE 0 END) AS REAL)
         * 100.0 / cc.total_impressions AS last_day_pct
FROM ad_impressions a
JOIN campaign_dates cd ON a.ad_campaign = cd.ad_campaign
JOIN campaign_counts cc ON a.ad_campaign = cc.ad_campaign
GROUP BY a.ad_campaign
ORDER BY a.ad_campaign
