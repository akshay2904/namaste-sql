-- ======================================================================
-- The Widest Net
-- ======================================================================
-- Difficulty : Medium
-- Company    : Travelport
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaign_click_through_rates
-- ======================================================================

/*
The ad analytics team wants each campaign's true reach: how many different registered users clicked at least one of its ads, counting a person once however many times they clicked. Keep campaigns that drew no clicks at all, and list the widest-reaching first.

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

Expected output ['ad_campaign', 'users_reached']:
  ['LOYALTY_PROGRAM', 13]
  ['SUMMER_SALE_2024', 6]
  ['BRAND_AWARENESS_Q1', 1]
  ['FLASH_SALE_48H', 1]
  ['HOLIDAY_PROMO', 1]
*/


-- Write your SQL solution below:

SELECT ai.ad_campaign,
       COUNT(DISTINCT CASE WHEN ai.clicked = 1 THEN ai.user_id END) AS users_reached
FROM ad_impressions ai
GROUP BY ai.ad_campaign
ORDER BY users_reached DESC, ai.ad_campaign ASC
