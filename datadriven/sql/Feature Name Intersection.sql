-- ======================================================================
-- Feature Name Intersection
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/feature_name_intersection
-- ======================================================================

/*
The ML feature store pulls feature names from two sources: 'ad_impressions' and 'search_queries'. Find which feature names appear in both sources.

Table: ml_features(feat_id, feat_name, dtype, avg_val, null_pct, updated, source)

Sample data - ml_features ['feat_id', 'feat_name', 'dtype', 'avg_val', 'null_pct', 'updated', 'source']:
  [141, 'login_count', 'int64', 7.3, 3, '2026-02-02', 'transactions']
  [182, 'cart_value', 'float32', 14.6, 6, '2026-03-03', 'page_views']
  [223, 'page_dwell', 'string', 21.9, 9, '2026-04-04', 'ad_impressions']
  [264, 'click_rate', 'boolean', 29.2, 12, '2026-05-05', None]
  [305, 'days_active', 'Float64', 36.5, 15, '2026-06-06', 'search_queries']

Expected output ['feat_name', 'ad_rows', 'search_rows', 'last_seen_ad', 'last_seen_search']:
  ['bounce_cnt', 6, 4, '2026-12-04', '2026-10-14']
  ['days_active', 4, 6, '2026-12-08', '2026-10-18']
  ['login_count', 6, 4, '2026-12-12', '2026-10-22']
  ['page_dwell', 6, 6, '2026-12-28', '2026-10-10']
  ['session_len', 4, 4, '2026-08-12', '2026-06-22']
*/


-- Write your SQL solution below:

WITH source_presence AS (
    SELECT
        feat_name,
        COUNT(*) FILTER (WHERE source = 'ad_impressions') AS ad_rows,
        COUNT(*) FILTER (WHERE source = 'search_queries') AS search_rows,
        MAX(CASE WHEN source = 'ad_impressions' THEN updated END) AS last_seen_ad,
        MAX(CASE WHEN source = 'search_queries' THEN updated END) AS last_seen_search
    FROM ml_features
    WHERE source IS NOT NULL
    GROUP BY feat_name
),
shared AS (
    SELECT feat_name, ad_rows, search_rows, last_seen_ad, last_seen_search
    FROM source_presence
    WHERE ad_rows > 0 AND search_rows > 0
)
SELECT
    feat_name,
    ad_rows,
    search_rows,
    last_seen_ad,
    last_seen_search
FROM shared
ORDER BY feat_name;
