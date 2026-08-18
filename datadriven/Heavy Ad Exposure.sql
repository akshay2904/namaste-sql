-- ======================================================================
-- Heavy Ad Exposure
-- ======================================================================
-- Difficulty : Medium
-- Company    : Shell
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/heavy_ad_exposure
-- ======================================================================

/*
A user qualifies as heavy ad exposure if they have 3 or more impressions from a single campaign, or if they have 5 or more total impressions spread across at least 2 different campaigns. Return the qualifying user IDs.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['user_id']:
  [100]
  [197]
  [294]
  [391]
  [488]
*/


-- Write your SQL solution below:

WITH per_campaign AS (
  SELECT user_id, ad_campaign, COUNT(*) AS impressions
  FROM ad_impressions
  WHERE user_id IS NOT NULL
  GROUP BY user_id, ad_campaign
),
per_user AS (
  SELECT user_id,
         MAX(impressions) AS hottest_campaign,
         SUM(impressions) AS total_impressions,
         COUNT(*) AS campaign_count
  FROM per_campaign
  GROUP BY user_id
)
SELECT user_id
FROM per_user
WHERE hottest_campaign >= 3
   OR (total_impressions >= 5 AND campaign_count >= 2)
ORDER BY user_id
