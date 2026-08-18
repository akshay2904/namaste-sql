-- ======================================================================
-- Who's Looking
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unique_searchers_count
-- ======================================================================

/*
The search quality team wants to know which search terms are reaching the widest audience. For each term, count how many different users searched it, with the widest reach first.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['search_term', 'unique_searchers']:
  ['4k monitor', 5]
  ['bluetooth speaker', 5]
  ['external ssd 1tb', 4]
  ['external ssd 1tb123', 1]
  ['ergonomic chair', 0]
*/


-- Write your SQL solution below:

SELECT search_term,
       COUNT(DISTINCT user_id) AS unique_searchers
FROM search_queries
GROUP BY search_term
ORDER BY unique_searchers DESC, search_term
