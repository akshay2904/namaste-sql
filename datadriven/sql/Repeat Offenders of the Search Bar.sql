-- ======================================================================
-- Repeat Offenders of the Search Bar
-- ======================================================================
-- Difficulty : Easy
-- Company    : Capital One
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/heavy_searchers_in_august
-- ======================================================================

/*
The search team flags a 'repeat searcher' as any user who ran more than one search query during the year 2026. How many repeat searchers were there in 2026?

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['repeat_searcher_count']:
  [16]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS repeat_searcher_count
FROM (
    SELECT user_id
    FROM search_queries
    WHERE strftime('%Y', query_time) = '2026'
    GROUP BY user_id
    HAVING COUNT(*) > 1
)
