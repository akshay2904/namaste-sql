-- ======================================================================
-- Keyword-Based User Search
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/keyword_based_user_search
-- ======================================================================

/*
We ran a search quality audit and need to find users whose search terms contain 'desk', 'monitor', 'cable', or 'mouse' in singular form only. Exclude any entries that use the plural forms of those words. Return unique user IDs only.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['user_id']:
  [294]
  [None]
  [585]
  [682]
  [1652]
*/


-- Write your SQL solution below:

SELECT DISTINCT user_id
FROM search_queries
WHERE (
        LOWER(search_term) LIKE '%desk%'
     OR LOWER(search_term) LIKE '%monitor%'
     OR LOWER(search_term) LIKE '%cable%'
     OR LOWER(search_term) LIKE '%mouse%'
      )
  AND LOWER(search_term) NOT LIKE '%desks%'
  AND LOWER(search_term) NOT LIKE '%monitors%'
  AND LOWER(search_term) NOT LIKE '%cables%'
  AND LOWER(search_term) NOT LIKE '%mouses%'
