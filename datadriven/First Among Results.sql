-- ======================================================================
-- First Among Results
-- ======================================================================
-- Difficulty : Hard
-- Company    : ESPN
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/search_term_length_vs_click_rates
-- ======================================================================

/*
The search relevance team wants to know whether longer queries make shoppers settle for the top hit. In `search_queries`, `clicked_result` holds the position of the result a shopper clicked, where 1 is the top result and an empty value means no click. For each search term length, show the total number of queries and how many ended in a click on that top result, from shortest term to longest.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['term_length', 'query_count', 'clicked_count']:
  [8, 10, 0]
  [10, 10, 0]
  [11, 22, 4]
  [12, 44, 0]
  [19, 22, 8]
*/


-- Write your SQL solution below:

SELECT LENGTH(search_term) AS term_length, COUNT(*) AS query_count, SUM(CASE WHEN clicked_result = 1 THEN 1 ELSE 0 END) AS clicked_count
FROM search_queries
WHERE search_term IS NOT NULL
GROUP BY term_length
ORDER BY term_length
