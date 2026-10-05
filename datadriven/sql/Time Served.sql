-- ======================================================================
-- Time Served
-- ======================================================================
-- Difficulty : Hard
-- Company    : Yammer
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/tenure_spread_for_active_tokens
-- ======================================================================

/*
Security is profiling the API tokens still in service, split out by permission scope. A token counts as in service when it has no expiration date, or its expiration is today or later. Within each scope, report the day span between its oldest and newest tokens, along with how many tokens were issued on that oldest day and how many on that newest day, widest span first.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['scope', 'day_spread', 'tokens_at_earliest', 'tokens_at_latest']:
  ['full_access', 1461, 1, 1]
  ['read:users', 1293, 1, 1]
  ['read:analytics', 1103, 1, 1]
  ['read', 907, 1, 1]
  ['admin', 899, 1, 1]
*/


-- Write your SQL solution below:

WITH active_tokens AS (
    SELECT scope, issued
    FROM api_tokens
    WHERE expires IS NULL OR expires >= DATE('now')
),
bounds AS (
    SELECT scope,
           MIN(issued) AS min_issued,
           MAX(issued) AS max_issued
    FROM active_tokens
    GROUP BY scope
)
SELECT
    b.scope,
    CAST(JULIANDAY(b.max_issued) - JULIANDAY(b.min_issued) AS INTEGER) AS day_spread,
    (SELECT COUNT(*) FROM active_tokens a WHERE a.scope = b.scope AND a.issued = b.min_issued) AS tokens_at_earliest,
    (SELECT COUNT(*) FROM active_tokens a WHERE a.scope = b.scope AND a.issued = b.max_issued) AS tokens_at_latest
FROM bounds b
ORDER BY day_spread DESC, b.scope
