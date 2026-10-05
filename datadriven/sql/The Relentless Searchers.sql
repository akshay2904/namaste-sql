-- ======================================================================
-- The Relentless Searchers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/rank_users_by_search_query_count
-- ======================================================================

/*
Rank users by total search queries, most active at rank 1. Users with the same count should fall in alphabetical sequence by user ID (treated as text), and every user gets a unique rank with no ties.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['user_id', 'query_count', 'rnk']:
  [None, 50, 1]
  [100, 2, 2]
  [1070, 2, 3]
  [1264, 2, 4]
  [1361, 2, 5]
*/


-- Write your SQL solution below:

SELECT user_id, query_count, rnk
FROM (
    SELECT
        user_id,
        COUNT(*) AS query_count,
        ROW_NUMBER() OVER (
            ORDER BY COUNT(*) DESC, CAST(user_id AS TEXT) ASC
        ) AS rnk
    FROM search_queries
    GROUP BY user_id
) ranked
