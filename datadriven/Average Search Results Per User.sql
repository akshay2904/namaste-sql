-- ======================================================================
-- Average Search Results Per User
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_search_results_per_user
-- ======================================================================

/*
The personalization team is investigating whether some users consistently see richer search results than others. For each user who has issued at least one search, show their average number of results returned.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['user_id', 'avg_results']:
  [100, 17]
  [197, 34]
  [294, 51]
  [488, 85]
  [585, 102]
*/


-- Write your SQL solution below:

SELECT user_id, AVG(results_count) AS avg_results
FROM search_queries
WHERE user_id IS NOT NULL
GROUP BY user_id
ORDER BY user_id
