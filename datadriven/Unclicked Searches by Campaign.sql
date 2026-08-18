-- ======================================================================
-- Unclicked Searches by Campaign
-- ======================================================================
-- Difficulty : Medium
-- Company    : Apple
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unclicked_searches_by_campaign
-- ======================================================================

/*
Our ad platform logs search queries with campaign tags. Count how many search queries were performed per ad campaign, broken down by whether the user clicked a result or not. Show the campaign, click status, and event count.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Expected output ['ad_campaign', 'clicked_result', 'event_count']:
  ['BRAND_AWARENESS_Q1', None, 14]
  ['BRAND_AWARENESS_Q1', 2, 8]
  ['BRAND_AWARENESS_Q1', 6, 6]
  ['BRAND_AWARENESS_Q1', 8, 8]
  ['FLASH_SALE_48H', None, 10]
*/


-- Write your SQL solution below:

SELECT
    a.ad_campaign,
    s.clicked_result,
    COUNT(*) AS event_count
FROM search_queries s
JOIN ad_impressions a ON s.user_id = a.user_id
GROUP BY a.ad_campaign, s.clicked_result
ORDER BY a.ad_campaign, s.clicked_result
