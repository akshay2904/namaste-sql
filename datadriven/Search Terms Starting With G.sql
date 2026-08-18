-- ======================================================================
-- Search Terms Starting With G
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/search_terms_starting_with_g
-- ======================================================================

/*
The search relevance team is debugging why queries starting with 'g' return fewer results than expected. Pull all such search terms alongside their results count.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['search_term', 'results_count']:
  ['gaming mouse', 68]
  ['gaming mouse', 408]
  ['gaming mouse', 248]
  ['gming mouse', None]
  ['gming mouse', None]
*/


-- Write your SQL solution below:

SELECT search_term, results_count
FROM search_queries
WHERE search_term LIKE 'g%'
