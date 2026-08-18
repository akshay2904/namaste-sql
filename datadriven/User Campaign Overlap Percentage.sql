-- ======================================================================
-- User Campaign Overlap Percentage
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/user_campaign_overlap_percentage
-- ======================================================================

/*
For every pair of users, calculate the overlap ratio of shared ad campaigns relative to the smaller user's campaign set. Include only pairs that share at least one campaign. Show the two user IDs, the shared campaign count, and the overlap ratio.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['user_id_1', 'user_id_2', 'shared_campaigns', 'overlap_ratio']:
  [100, 294, 4, 1]
  [100, 488, 4, 1]
  [197, 2137, 1, 1]
  [197, 2234, 1, 1]
  [197, 3010, 2, 1]
*/


-- Write your SQL solution below:

WITH user_campaigns AS (
    SELECT DISTINCT user_id, ad_campaign
    FROM ad_impressions
),
user_counts AS (
    SELECT user_id, COUNT(*) AS campaign_count
    FROM user_campaigns
    GROUP BY user_id
)
SELECT
    a.user_id AS user_id_1,
    b.user_id AS user_id_2,
    COUNT(*) AS shared_campaigns,
    COUNT(*) * 1.0 / MIN(uc1.campaign_count, uc2.campaign_count) AS overlap_ratio
FROM user_campaigns a
JOIN user_campaigns b ON a.ad_campaign = b.ad_campaign AND a.user_id < b.user_id
JOIN user_counts uc1 ON a.user_id = uc1.user_id
JOIN user_counts uc2 ON b.user_id = uc2.user_id
GROUP BY a.user_id, b.user_id, uc1.campaign_count, uc2.campaign_count
HAVING COUNT(*) >= 1
