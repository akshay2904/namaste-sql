-- ======================================================================
-- Top Percentile API Tokens
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_percentile_api_tokens
-- ======================================================================

/*
Consider tokens at or above the 95th percentile by total requests within each scope as high-risk. Show the token ID, scope, request count, and percentile rank. Round to 2 decimal places.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['token_id', 'scope', 'requests', 'percentile_rank']:
  [5300, 'admin', 4700, 0.97]
  [10005400, 'admin', 4700, 0.97]
  [5171, 'full_access', 4559, 0.96]
  [10005397, 'full_access', 4559, 0.96]
  [5257, 'write', 4653, 0.97]
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT token_id, scope, requests,
         PERCENT_RANK() OVER (
           PARTITION BY scope
           ORDER BY requests ASC
         ) AS pct_rank
  FROM api_tokens
)
SELECT token_id, scope, requests,
       ROUND(pct_rank, 2) AS percentile_rank
FROM ranked
WHERE pct_rank >= 0.95
ORDER BY scope, requests DESC
