-- ======================================================================
-- Users With and Without Ad Clicks
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/users_with_and_without_ad_clicks
-- ======================================================================

/*
Count users who received at least one ad click versus those who did not. A user counts as clicked if they have any clicked ad impression. Show each group (has click or not) and its user count.

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

Expected output ['click_group', 'user_count']:
  ['has_click', 16]
  ['no_click', 184]
*/


-- Write your SQL solution below:

SELECT
    CASE WHEN c.user_id IS NOT NULL THEN 'has_click' ELSE 'no_click' END AS click_group,
    COUNT(*) AS user_count
FROM users u
LEFT JOIN (
    SELECT DISTINCT user_id
    FROM ad_impressions
    WHERE clicked = 1
) c ON u.user_id = c.user_id
GROUP BY click_group
