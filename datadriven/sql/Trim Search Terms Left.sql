-- ======================================================================
-- Trim Search Terms Left
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/trim_search_terms_left
-- ======================================================================

/*
A data quality check flagged leading whitespace in some search terms. Return a cleaned-up list showing each search term with the leading spaces stripped, by query ID.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['query_id', 'search_term']:
  [2071, 'laptop deals']
  [2142, 'phone case iphone 15']
  [2213, 'usb-c cable 6ft']
  [2284, 'gaming mouse']
  [2355, 'mechanical keyboard']
*/


-- Write your SQL solution below:

SELECT query_id, LTRIM(search_term) AS search_term
FROM search_queries
