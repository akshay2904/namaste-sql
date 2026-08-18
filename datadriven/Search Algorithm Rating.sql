-- ======================================================================
-- Search Algorithm Rating
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/search_algorithm_rating
-- ======================================================================

/*
We need a search quality score for each query. Assign a rating: 1 if no result was clicked, 2 if a result was clicked but the top clicked position was outside the top 3, and 3 if a result was clicked in positions 1 through 3. Show each query ID and its rating.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['query_id', 'rating']:
  [2071, None]
  [2142, None]
  [2213, None]
  [2710, 2]
  [3420, 2]
*/


-- Write your SQL solution below:

SELECT
    query_id,
    CASE
        WHEN clicked_result = 0 THEN 1
        WHEN clicked_result = 1 AND results_count > 3 THEN 2
        WHEN clicked_result = 1 AND results_count <= 3 THEN 3
    END AS rating
FROM search_queries
