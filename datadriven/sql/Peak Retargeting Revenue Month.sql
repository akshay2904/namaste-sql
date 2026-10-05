-- ======================================================================
-- Peak Retargeting Revenue Month
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_retargeting_revenue_month
-- ======================================================================

/*
For retargeting campaigns (names containing 'retarget') in 2026, which month had the highest total ad revenue? Show the month, total revenue, maximum single-impression revenue, and average revenue.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['mnth', 'total_revenue', 'max_revenue', 'avg_revenue']:
  ['2026-04', 2.3, 2.3, 2.3]
*/


-- Write your SQL solution below:

SELECT strftime('%Y-%m', impression_time) AS mnth, SUM(revenue) AS total_revenue, MAX(revenue) AS max_revenue, AVG(revenue) AS avg_revenue FROM ad_impressions WHERE ad_campaign LIKE '%retarget%' AND strftime('%Y', impression_time) = '2026' GROUP BY mnth ORDER BY total_revenue DESC LIMIT 1
