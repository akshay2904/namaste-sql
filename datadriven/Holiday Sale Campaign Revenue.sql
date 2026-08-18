-- ======================================================================
-- Holiday Sale Campaign Revenue
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/holiday_sale_campaign_revenue
-- ======================================================================

/*
Surface every impression from the holiday sale campaign along with the associated user and their revenue. Include impressions even if the user has no revenue recorded. Return all available fields for each row.

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

Expected output ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [836, None, 'HOLIDAY_PROMO', '2026-01-13 12:24:00', 0, None, None, None, None, None, None]
  [1260, 973, 'HOLIDAY_PROMO', '2026-09-21 20:20:00', 1, 0.65, 'brian', 'brian@example.com', '2025-11-11', 'suspended', '45-54']
  [1684, 779, 'HOLIDAY_PROMO', '2026-05-01 04:16:00', 0, None, 'aiden', 'aiden@example.com', '2026-09-09', 'active', '25-34']
  [3380, None, 'HOLIDAY_PROMO', '2026-01-05 12:00:00', 1, 1.85, None, None, None, None, None]
*/


-- Write your SQL solution below:

SELECT ai.impression_id, ai.user_id, ai.ad_campaign, ai.impression_time, ai.clicked, ai.revenue, u.username, u.email, u.signup_date, u.account_status, u.age_bucket FROM ad_impressions ai LEFT JOIN users u ON ai.user_id = u.user_id WHERE ai.ad_campaign LIKE '%holiday%' ORDER BY ai.impression_id
