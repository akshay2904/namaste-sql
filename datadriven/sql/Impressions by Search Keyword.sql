-- ======================================================================
-- Impressions by Search Keyword
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/impressions_by_search_keyword
-- ======================================================================

/*
For each search term that contains 'laptop', count how many ad impressions came from users who searched that term. Rank sorted from most impressions to least.

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

Expected output ['search_term', 'impression_count']:
  ['laptop deals', 14]
*/


-- Write your SQL solution below:

SELECT su.search_term, COUNT(*) AS impression_count
FROM (
  SELECT DISTINCT search_term, user_id
  FROM search_queries
  WHERE search_term LIKE '%laptop%'
) su
INNER JOIN ad_impressions ai ON ai.user_id = su.user_id
GROUP BY su.search_term
ORDER BY impression_count DESC, su.search_term ASC;
