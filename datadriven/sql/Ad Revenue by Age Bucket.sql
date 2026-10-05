-- ======================================================================
-- Ad Revenue by Age Bucket
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/ad_revenue_by_age_bucket
-- ======================================================================

/*
The ad monetization team is evaluating which user demographics drive the most revenue. Show the total ad revenue for each age bucket, with the highest-earning buckets first. Exclude users who have no age bucket on file.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['age_bucket', 'total_revenue']:
  ['65+', 55.85]
  ['45-54', 45.7]
  ['55-64', 36.05]
  ['35-44', 28.75]
  ['25-34', 26.25]
*/


-- Write your SQL solution below:

SELECT u.age_bucket,
       SUM(ai.revenue) AS total_revenue
FROM ad_impressions ai
INNER JOIN users u
  ON ai.user_id = u.user_id
WHERE u.age_bucket IS NOT NULL
GROUP BY u.age_bucket
ORDER BY total_revenue DESC
