-- ======================================================================
-- Every Touch Counts
-- ======================================================================
-- Difficulty : Medium
-- Company    : Copart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-most-engaged-shoppers
-- ======================================================================

/*
We run an online vehicle auction marketplace and want to surface our most engaged shoppers from 2026. Treating every ad impression and every site search a person made that year as one touchpoint, total the touchpoints per user across both sources, most active first.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['user_id', 'touchpoint_count']:
  [None, 47]
  [488, 15]
  [100, 11]
  [294, 11]
  [682, 11]
*/


-- Write your SQL solution below:

SELECT user_id,
       COUNT(*) AS touchpoint_count
FROM (
    SELECT user_id FROM ad_impressions
    WHERE strftime('%Y', impression_time) = '2026'
    UNION ALL
    SELECT user_id FROM search_queries
    WHERE strftime('%Y', query_time) = '2026'
) activity
GROUP BY user_id
ORDER BY touchpoint_count DESC, user_id
