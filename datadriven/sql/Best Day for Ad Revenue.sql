-- ======================================================================
-- Best Day for Ad Revenue
-- ======================================================================
-- Difficulty : Medium
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/best_day_for_ad_revenue
-- ======================================================================

/*
The ad team wants to see which calendar days carry the strongest click premium: the gap between average revenue on clicked impressions and on non-clicked ones. Break the numbers down by day of the month (1 through 31), and for each day report the overall average revenue, the biggest single-impression revenue, and that click premium, widest premium first.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['day_of_month', 'avg_revenue', 'max_revenue', 'click_premium']:
  [1, None, None, None]
  [2, 2.6, 2.6, None]
  [3, 0.95, 0.95, None]
  [4, None, None, None]
  [5, 1.925, 2, None]
*/


-- Write your SQL solution below:

SELECT
  CAST(strftime('%d', impression_time) AS INTEGER) AS day_of_month,
  AVG(revenue) AS avg_revenue,
  MAX(revenue) AS max_revenue,
  AVG(CASE WHEN clicked = 1 THEN revenue END)
    - AVG(CASE WHEN clicked = 0 THEN revenue END) AS click_premium
FROM ad_impressions
GROUP BY day_of_month
ORDER BY click_premium DESC, day_of_month
