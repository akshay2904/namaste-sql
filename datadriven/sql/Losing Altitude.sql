-- ======================================================================
-- Losing Altitude
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaign_engagement_rank_shift
-- ======================================================================

/*
A stakeholder flagged that some ad campaigns lost momentum between June and October of 2026. Within each of those two months, campaigns are placed by how many of their impressions were clicked, most first; surface the campaigns that sat lower in October than they did in June.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign']:
  ['SUMMER_SALE_2024']
*/


-- Write your SQL solution below:

WITH monthly_clicks AS (
  SELECT ad_campaign, strftime('%Y-%m', impression_time) AS ym,
         COUNT(CASE WHEN clicked = 1 THEN 1 END) AS total_clicks
  FROM ad_impressions
  WHERE strftime('%Y-%m', impression_time) IN ('2026-06', '2026-10')
  GROUP BY ad_campaign, strftime('%Y-%m', impression_time)
),
ranked AS (
  SELECT ad_campaign, ym, DENSE_RANK() OVER (PARTITION BY ym ORDER BY total_clicks DESC) AS rnk
  FROM monthly_clicks
)
SELECT d.ad_campaign
FROM ranked d INNER JOIN ranked j ON d.ad_campaign = j.ad_campaign
WHERE d.ym = '2026-06' AND j.ym = '2026-10' AND j.rnk > d.rnk
ORDER BY d.ad_campaign
