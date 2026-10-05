-- ======================================================================
-- No Dead Months
-- ======================================================================
-- Difficulty : Hard
-- Company    : Uber
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_efficient_high_volume_campaign
-- ======================================================================

/*
We're building a leaderboard of ad campaigns, but a campaign only earns a spot if it drew at least one click in every calendar month it was active. Among the campaigns that clear that bar, order them by their single heaviest month of revenue, lowest peak first, and return just the campaign name.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign']:
  ['LOYALTY_PROGRAM']
*/


-- Write your SQL solution below:

WITH monthly AS (
    SELECT ad_campaign,
           STRFTIME('%Y-%m', impression_time) AS month,
           SUM(CASE WHEN clicked = 1 THEN 1 ELSE 0 END) AS monthly_clicks,
           SUM(revenue) AS monthly_spend
    FROM ad_impressions
    GROUP BY ad_campaign, STRFTIME('%Y-%m', impression_time)
)
SELECT ad_campaign
FROM monthly
GROUP BY ad_campaign
HAVING MIN(monthly_clicks) >= 1
ORDER BY MAX(monthly_spend) ASC, ad_campaign ASC;
