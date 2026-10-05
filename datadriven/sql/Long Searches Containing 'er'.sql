-- ======================================================================
-- Long Searches Containing 'er'
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/long_searches_containing_er
-- ======================================================================

/*
The search analytics team is investigating long-tail query patterns. Pull all search queries where the term is longer than 12 characters and ends with the letter 'r' (case-insensitive). Return all fields, ordered by query ID.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2639, 876, 'bluetooth speaker', 153, None, '2026-10-10 09:39:00']
  [3136, None, 'ergonomic chair', 272, 7, '2026-05-17 16:56:00']
  [4059, 2816, 'bluetooth speaker', 493, 10, '2026-06-02 05:19:00']
  [4556, None, 'ergonomic chair', 112, None, '2026-01-09 12:36:00']
  [5479, 4756, 'bluetooth speaker', 333, 10, '2026-02-22 01:59:00']
*/


-- Write your SQL solution below:

SELECT query_id, user_id, search_term, results_count, clicked_result, query_time
FROM search_queries
WHERE LENGTH(search_term) > 12
    AND LOWER(search_term) LIKE '%r'
ORDER BY query_id
