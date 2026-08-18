-- ======================================================================
-- First Interaction Credit
-- ======================================================================
-- Difficulty : Hard
-- Company    : Netflix
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_interaction_credit
-- ======================================================================

/*
The attribution team uses a first-touch model: every conversion is credited to the very first ad impression the user ever received, regardless of whether they clicked. A user counts as converted if they appear in the transactions table. For each converted user, return their user_id, the ad_campaign from their earliest impression, and that impression_time.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'ad_campaign', 'impression_time']:
  [100, 'BRAND_AWARENESS_Q1', '2022-01-02 01:07:00']
  [197, 'PRODUCT_LAUNCH_X', '2023-02-03 02:14:00']
  [294, 'NEW_USER_ACQU', '2024-01-14 13:31:00']
  [391, 'LOYALTY_PROGRAM', '2025-02-15 14:38:00']
  [488, 'BRAND_AWARENESS_Q1', '2026-01-26 01:55:00']
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT
    i.user_id,
    i.ad_campaign,
    i.impression_time,
    ROW_NUMBER() OVER (
      PARTITION BY i.user_id
      ORDER BY i.impression_time
    ) AS rn
  FROM ad_impressions i
  WHERE EXISTS (
    SELECT 1 FROM transactions t WHERE t.user_id = i.user_id
  )
)
SELECT user_id, ad_campaign, impression_time
FROM ranked
WHERE rn = 1;
