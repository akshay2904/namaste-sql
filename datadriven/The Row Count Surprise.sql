-- ======================================================================
-- The Row Count Surprise
-- ======================================================================
-- Difficulty : Easy
-- Company    : Dell Technologies
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/join_type_row_counts
-- ======================================================================

/*
The data quality team is auditing how a users-vs-ad_impressions join behaves under the three classic semantics. Some users were never served an impression, and some impressions don't tie back to a known user. In a single result set, surface three rows labeled inner_join, left_join, and full_outer_join, each with the total row count that combination produces.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['join_type', 'row_count']:
  ['inner_join', 179]
  ['left_join', 354]
  ['full_outer_join', 375]
*/


-- Write your SQL solution below:

SELECT 'inner_join' AS join_type, COUNT(*) AS row_count
FROM users u
INNER JOIN ad_impressions ai ON u.user_id = ai.user_id
UNION ALL
SELECT 'left_join', COUNT(*)
FROM users u
LEFT JOIN ad_impressions ai ON u.user_id = ai.user_id
UNION ALL
SELECT 'full_outer_join', COUNT(*)
FROM (
    SELECT u.user_id, ai.impression_id
    FROM users u
    LEFT JOIN ad_impressions ai ON u.user_id = ai.user_id
    UNION ALL
    SELECT u.user_id, ai.impression_id
    FROM ad_impressions ai
    LEFT JOIN users u ON ai.user_id = u.user_id
    WHERE u.user_id IS NULL
)
