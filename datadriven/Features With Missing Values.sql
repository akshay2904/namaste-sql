-- ======================================================================
-- Features With Missing Values
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/features_with_missing_values
-- ======================================================================

/*
The ML team is debugging a model training failure caused by null feature values. Surface every record in the feature store where the average value is missing.

Table: ml_features(feat_id, feat_name, dtype, avg_val, null_pct, updated, source)

Sample data - ml_features ['feat_id', 'feat_name', 'dtype', 'avg_val', 'null_pct', 'updated', 'source']:
  [141, 'login_count', 'int64', 7.3, 3, '2026-02-02', 'transactions']
  [182, 'cart_value', 'float32', 14.6, 6, '2026-03-03', 'page_views']
  [223, 'page_dwell', 'string', 21.9, 9, '2026-04-04', 'ad_impressions']
  [264, 'click_rate', 'boolean', 29.2, 12, '2026-05-05', None]
  [305, 'days_active', 'Float64', 36.5, 15, '2026-06-06', 'search_queries']

Expected output ['feat_id', 'feat_name', 'dtype', 'avg_val', 'null_pct', 'updated', 'source']:
  [1576, 'avg_order', 'int64', None, None, '2026-01-09', None]
  [592, 'cart_value', 'Float64', None, 36, '2026-01-13', None]
  [1084, 'click_rate', 'string', None, 72, '2026-01-25', 'user_sessions']
  [2068, 'scroll_pct', 'INT64', None, 44, '2026-01-21', 'user_sessions']
  [2560, 'user_age', 'boolean', None, 80, '2026-01-05', None]
*/


-- Write your SQL solution below:

SELECT *
FROM ml_features
WHERE avg_val IS NULL
ORDER BY feat_name, feat_id
