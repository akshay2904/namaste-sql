-- ======================================================================
-- Transaction Source Features
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/transaction_source_features
-- ======================================================================

/*
Return all feature names from the transactions source that have a recorded average value.

Table: ml_features(feat_id, feat_name, dtype, avg_val, null_pct, updated, source)

Sample data - ml_features ['feat_id', 'feat_name', 'dtype', 'avg_val', 'null_pct', 'updated', 'source']:
  [141, 'login_count', 'int64', 7.3, 3, '2026-02-02', 'transactions']
  [182, 'cart_value', 'float32', 14.6, 6, '2026-03-03', 'page_views']
  [223, 'page_dwell', 'string', 21.9, 9, '2026-04-04', 'ad_impressions']
  [264, 'click_rate', 'boolean', 29.2, 12, '2026-05-05', None]
  [305, 'days_active', 'Float64', 36.5, 15, '2026-06-06', 'search_queries']

Expected output ['feat_name']:
  ['bounce_cnt']
  ['days_active']
  ['login_count']
  ['page_dwell']
  ['session_len']
*/


-- Write your SQL solution below:

SELECT DISTINCT feat_name
FROM ml_features
WHERE source = 'transactions'
  AND avg_val IS NOT NULL
ORDER BY feat_name
