-- ======================================================================
-- The Campaign Trail
-- ======================================================================
-- Difficulty : Easy
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_campaign_trail
-- ======================================================================

/*
The ad ops team is deciding which 2025 campaigns to renew. Which campaigns crossed the $5 total revenue threshold that year? Return their names.

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

SELECT ad_campaign
FROM ad_impressions
WHERE strftime('%Y', impression_time) = '2025'
GROUP BY ad_campaign
HAVING SUM(revenue) > 5
ORDER BY ad_campaign
