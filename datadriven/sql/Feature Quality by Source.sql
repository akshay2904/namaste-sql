-- ======================================================================
-- Feature Quality by Source
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/feature_quality_by_source
-- ======================================================================

/*
Find sources in the ML feature store that have both high-null features (null percentage above 20) and low-null features (null percentage below 2). For each qualifying source, count how many different features fall into each bucket. Include sources even if one bucket is empty.

Table: ml_features(feat_id, feat_name, dtype, avg_val, null_pct, updated, source)

Sample data - ml_features ['feat_id', 'feat_name', 'dtype', 'avg_val', 'null_pct', 'updated', 'source']:
  [141, 'login_count', 'int64', 7.3, 3, '2026-02-02', 'transactions']
  [182, 'cart_value', 'float32', 14.6, 6, '2026-03-03', 'page_views']
  [223, 'page_dwell', 'string', 21.9, 9, '2026-04-04', 'ad_impressions']
  [264, 'click_rate', 'boolean', 29.2, 12, '2026-05-05', None]
  [305, 'days_active', 'Float64', 36.5, 15, '2026-06-06', 'search_queries']

Expected output ['source', 'high_null_count', 'low_null_count']:
  ['ad_impressions', 4, 1]
*/


-- Write your SQL solution below:

WITH high_null AS (
  SELECT source
  FROM ml_features
  WHERE null_pct > 20
  GROUP BY source
),
low_null AS (
  SELECT source
  FROM ml_features
  WHERE null_pct < 2
  GROUP BY source
)
SELECT
  f.source,
  COUNT(DISTINCT CASE WHEN f.null_pct > 20 THEN f.feat_name END) AS high_null_count,
  COUNT(DISTINCT CASE WHEN f.null_pct < 2 THEN f.feat_name END) AS low_null_count
FROM ml_features f
LEFT JOIN high_null h ON f.source = h.source
LEFT JOIN low_null l ON f.source = l.source
WHERE h.source IS NOT NULL AND l.source IS NOT NULL
GROUP BY f.source
