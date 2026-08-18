-- ======================================================================
-- Campaign Conversion Window
-- ======================================================================
-- Difficulty : Hard
-- Company    : Workday
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaign_conversion_window
-- ======================================================================

/*
Our ad platform logs impressions, clicks, and purchases. For each campaign, compute the click-through rate and the conversion rate as percentages rounded to 2 decimal places. A conversion means a user who clicked an ad and then made a purchase within 7 days. Only include campaigns with at least 3 impressions.

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

Expected output ['ad_campaign', 'impressions', 'clicks', 'ctr_pct', 'conversions', 'conversion_rate_pct']:
  ['PRODUCT_LAUNCH_X', 18, 4, 22.22, 1, 100]
  ['NEW_USER_ACQU', 16, 4, 25, 1, 100]
  ['SUMMER_SALE_2024', 22, 7, 31.82, 0, 0]
  ['RETARGETING_CART', 17, 2, 11.76, 0, 0]
  ['LOYALTY_PROGRAM', 76, 63, 82.89, 0, 0]
*/


-- Write your SQL solution below:

SELECT
  ai.ad_campaign,
  COUNT(*) AS impressions,
  SUM(ai.clicked) AS clicks,
  ROUND(CAST(SUM(ai.clicked) AS REAL) / COUNT(*) * 100, 2) AS ctr_pct,
  COUNT(DISTINCT CASE WHEN ai.clicked = 1 AND t.transaction_id IS NOT NULL THEN ai.user_id END) AS conversions,
  ROUND(
    CAST(COUNT(DISTINCT CASE WHEN ai.clicked = 1 AND t.transaction_id IS NOT NULL THEN ai.user_id END) AS REAL)
    / NULLIF(COUNT(DISTINCT CASE WHEN ai.clicked = 1 THEN ai.user_id END), 0) * 100, 2
  ) AS conversion_rate_pct
FROM ad_impressions ai
LEFT JOIN transactions t
  ON ai.user_id = t.user_id
 AND ai.clicked = 1
 AND julianday(t.transaction_date) - julianday(date(ai.impression_time)) BETWEEN 0 AND 7
GROUP BY ai.ad_campaign
HAVING COUNT(*) >= 3
ORDER BY conversion_rate_pct DESC;
