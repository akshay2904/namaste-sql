-- ======================================================================
-- All at Once
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_concurrent_tokens
-- ======================================================================

/*
For every API token ever issued, find the largest number of tokens that were active at the same time during this token's own active window, and the earliest date that peak was reached. A token counts as active from its issued date through the day before it expires, and a token with no expiration is treated as still active.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['token_id', 'peak_concurrent', 'peak_date']:
  [1043, 116, '2026-12-05']
  [1086, 116, '2026-12-05']
  [1129, 116, '2026-12-05']
  [1172, 116, '2026-12-05']
  [1215, 116, '2026-12-05']
*/


-- Write your SQL solution below:

WITH event_days AS (
  SELECT DISTINCT DATE(issued) AS d
  FROM api_tokens
),
day_active AS (
  SELECT e.d AS d, COUNT(*) AS active_count
  FROM event_days e
  JOIN api_tokens b
    ON DATE(b.issued) <= e.d
   AND (b.expires IS NULL OR DATE(b.expires) > e.d)
  GROUP BY e.d
),
token_days AS (
  SELECT t.token_id, da.d AS d, da.active_count
  FROM api_tokens t
  JOIN day_active da
    ON da.d >= DATE(t.issued)
   AND (t.expires IS NULL OR da.d < DATE(t.expires))
),
ranked AS (
  SELECT token_id, d, active_count,
         MAX(active_count) OVER (PARTITION BY token_id) AS peak_concurrent
  FROM token_days
)
SELECT token_id, peak_concurrent, MIN(d) AS peak_date
FROM ranked
WHERE active_count = peak_concurrent
GROUP BY token_id, peak_concurrent
ORDER BY token_id
