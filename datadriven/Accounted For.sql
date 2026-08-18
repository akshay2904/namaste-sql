-- ======================================================================
-- Accounted For
-- ======================================================================
-- Difficulty : Medium
-- Company    : Rockerbox
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/attributable_impression_rate
-- ======================================================================

/*
The attribution team is auditing the ad log campaign by campaign, where an impression counts as traceable only when it maps to a known user account. For each campaign, find the percentage of its impressions that are traceable, most traceable first.

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

Expected output ['ad_campaign', 'attributable_pct']:
  ['BRAND_AWARENESS_Q1', 100]
  ['LOYALTY_PROGRAM', 92.1]
  ['SUMMER_SALE_2024', 77.3]
  ['PRODUCT_LAUNCH_X', 72.2]
  ['HOLIDAY_PROMO', 70.6]
*/


-- Write your SQL solution below:

SELECT ai.ad_campaign,
       ROUND(CAST(SUM(CASE WHEN u.user_id IS NOT NULL THEN 1 ELSE 0 END) AS REAL) * 100.0 / COUNT(*), 1) AS attributable_pct
FROM ad_impressions ai
LEFT JOIN users u ON ai.user_id = u.user_id
GROUP BY ai.ad_campaign
ORDER BY attributable_pct DESC, ai.ad_campaign
