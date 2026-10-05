-- ======================================================================
-- Average Results for Python Searches
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_results_for_python_searches
-- ======================================================================

/*
Users searching for keyboards have been complaining about empty result pages. Compute the average number of results returned for search queries whose term contains 'keyboard', regardless of casing.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['avg_results']:
  [265]
*/


-- Write your SQL solution below:

WITH classified AS (
    SELECT
        results_count,
        CASE
            WHEN INSTR(LOWER(search_term), 'keyboard') > 0 THEN 1
            ELSE 0
        END AS is_keyboard_search
    FROM search_queries
)
SELECT
    AVG(CASE WHEN is_keyboard_search = 1 THEN results_count END) AS avg_results
FROM classified
HAVING SUM(is_keyboard_search) > 0;
