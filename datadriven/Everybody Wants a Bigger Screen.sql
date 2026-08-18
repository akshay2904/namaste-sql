-- ======================================================================
-- Everybody Wants a Bigger Screen
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/product_page_sale_searches
-- ======================================================================

/*
The peripherals merchandising team is sizing display demand before the next buy and wants to know who keeps coming back to search for monitors. For each user in the search_queries log, count the searches whose term mentions a monitor, matching any capitalization so 'Monitor' and 'MONITOR' still count, and list the heaviest monitor searchers first.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['user_id', 'monitor_searches']:
  [585, 2]
  [1652, 2]
  [2525, 2]
  [3592, 2]
  [4465, 2]
*/


-- Write your SQL solution below:

SELECT user_id, COUNT(*) AS monitor_searches
FROM search_queries
WHERE LOWER(search_term) LIKE '%monitor%'
GROUP BY user_id
ORDER BY monitor_searches DESC, user_id
