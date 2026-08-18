-- ======================================================================
-- Diminishing Returns
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/click_vs_non_click_rates
-- ======================================================================

/*
A thin result set may change how often shoppers click a result. Split every search into three result-set sizes: none, a small set of one to three, and anything larger, then report each size's click-through rate as a percentage rounded to two decimals, from the highest rate down.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['result_bucket', 'click_through_pct']:
  ['small', 100]
  ['larger', 61.62]
*/


-- Write your SQL solution below:

SELECT
    CASE
        WHEN results_count = 0 THEN 'none'
        WHEN results_count <= 3 THEN 'small'
        ELSE 'larger'
    END AS result_bucket,
    ROUND(100.0 * SUM(CASE WHEN clicked_result IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS click_through_pct
FROM search_queries
GROUP BY result_bucket
ORDER BY click_through_pct DESC
