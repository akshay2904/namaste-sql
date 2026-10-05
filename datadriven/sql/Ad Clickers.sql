-- ======================================================================
-- Ad Clickers
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/ad_clickers
-- ======================================================================

/*
The monetization team is reviewing ad performance for the quarter. They want every user who clicked on at least one ad, along with the total revenue those clicks generated. Show each user's username and total click revenue, listed from the highest revenue contributor down.

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

Expected output ['username', 'total_revenue']:
  ['emma', 25.1]
  ['dora_77', 23.55]
  ['dimitri', 22]
  ['dahlia', 18.75]
  ['devon', 17.5]
*/


-- Write your SQL solution below:

SELECT
    u.username,
    SUM(a.revenue) AS total_revenue
FROM users u
JOIN ad_impressions a ON u.user_id = a.user_id
WHERE a.clicked = 1
GROUP BY u.username
ORDER BY total_revenue DESC, u.username ASC
