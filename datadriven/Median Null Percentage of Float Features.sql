-- ======================================================================
-- Median Null Percentage of Float Features
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/median_null_percentage_of_float_features
-- ======================================================================

/*
In the ML feature store, compute the median null percentage across all features that have a float-related data type (any dtype containing 'float').

Table: ml_features(feat_id, feat_name, dtype, avg_val, null_pct, updated, source)

Sample data - ml_features ['feat_id', 'feat_name', 'dtype', 'avg_val', 'null_pct', 'updated', 'source']:
  [141, 'login_count', 'int64', 7.3, 3, '2026-02-02', 'transactions']
  [182, 'cart_value', 'float32', 14.6, 6, '2026-03-03', 'page_views']
  [223, 'page_dwell', 'string', 21.9, 9, '2026-04-04', 'ad_impressions']
  [264, 'click_rate', 'boolean', 29.2, 12, '2026-05-05', None]
  [305, 'days_active', 'Float64', 36.5, 15, '2026-06-06', 'search_queries']

Expected output ['median_null_pct']:
  [48]
*/


-- Write your SQL solution below:

WITH float_features AS (
    SELECT null_pct
    FROM ml_features
    WHERE LOWER(dtype) LIKE '%float%'
      AND null_pct IS NOT NULL
),
ranked AS (
    SELECT
        null_pct,
        ROW_NUMBER() OVER (ORDER BY null_pct) AS rn,
        COUNT(*) OVER () AS total
    FROM float_features
)
SELECT AVG(null_pct) AS median_null_pct
FROM ranked
WHERE rn IN ((total + 1) / 2, (total + 2) / 2);
