-- ======================================================================
-- Only Here
-- ======================================================================
-- Difficulty : Hard
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/transaction_only_features
-- ======================================================================

/*
The ML team is isolating features that live only in the 'transactions' source and never surface in 'page_views' or 'ad_impressions', where two entries describe the same feature when they share a name and a data type. Those data-type labels were recorded inconsistently, so spellings like 'INT64' and 'int64' stand for the same type and count as one. A feature is logged many times, so collapse its entries into a single row reporting the feature name, data type, mean recorded value, and mean null percentage, ordered by feature name.

Table: ml_features(feat_id, feat_name, dtype, avg_val, null_pct, updated, source)

Sample data - ml_features ['feat_id', 'feat_name', 'dtype', 'avg_val', 'null_pct', 'updated', 'source']:
  [141, 'login_count', 'int64', 7.3, 3, '2026-02-02', 'transactions']
  [182, 'cart_value', 'float32', 14.6, 6, '2026-03-03', 'page_views']
  [223, 'page_dwell', 'string', 21.9, 9, '2026-04-04', 'ad_impressions']
  [264, 'click_rate', 'boolean', 29.2, 12, '2026-05-05', None]
  [305, 'days_active', 'Float64', 36.5, 15, '2026-06-06', 'search_queries']

Expected output ['feat_name', 'dtype', 'avg_val', 'null_pct']:
  ['bounce_cnt', 'float32', 65.7, None]
  ['days_active', 'boolean', 182.5, 75]
  ['login_count', 'int64', 153.3, 13]
  ['page_dwell', 'float64', 240.9, 99]
  ['session_len', 'string', 124.1, 51]
*/


-- Write your SQL solution below:

SELECT
  f.feat_name,
  LOWER(f.dtype) AS dtype,
  ROUND(AVG(f.avg_val), 2) AS avg_val,
  ROUND(AVG(f.null_pct), 2) AS null_pct
FROM ml_features f
WHERE f.source = 'transactions'
  AND NOT EXISTS (
    SELECT 1
    FROM ml_features o
    WHERE o.feat_name = f.feat_name
      AND LOWER(o.dtype) = LOWER(f.dtype)
      AND o.source IN ('page_views', 'ad_impressions')
  )
GROUP BY f.feat_name, LOWER(f.dtype)
ORDER BY f.feat_name, dtype
