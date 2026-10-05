-- ======================================================================
-- Revoked Tokens by Scope
-- ======================================================================
-- Difficulty : Medium
-- Company    : Southwest Airlines
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/revoked_tokens_by_scope
-- ======================================================================

/*
The trust and safety pipeline tracks revoked API tokens by scope. For December 2026, count revoked tokens per scope. Include tokens revoked before December whose expiration extends into at least part of the month. Tokens with no expiration are considered permanently revoked. Match status case-insensitively. Return the scope and blocked count.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['scope', 'blocked_count']:
  ['admin', 6]
  ['full_access', 6]
  ['read', 7]
  ['read:analytics', 8]
  ['read:users', 7]
*/


-- Write your SQL solution below:

SELECT scope, COUNT(*) AS blocked_count
FROM api_tokens
WHERE LOWER(status) = 'revoked' AND issued <= '2026-12-31' AND (expires IS NULL OR expires >= '2026-12-01')
GROUP BY scope
ORDER BY scope
