-- ======================================================================
-- Q2 Search Volume
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/q2_search_volume
-- ======================================================================

/*
The search team is benchmarking Q2 2026 query volume against the prior quarter. How many total search queries were received between April 1 and June 30 2026 inclusive?

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['q2_volume']:
  [32]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS q2_volume
FROM search_queries
WHERE query_time >= '2026-04-01'
  AND query_time < '2026-07-01'
