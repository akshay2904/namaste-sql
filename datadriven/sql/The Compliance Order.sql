-- ======================================================================
-- The Compliance Order
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/sort_tokens_by_scope_character
-- ======================================================================

/*
A compliance team needs API token scopes sorted for an audit trail. List all tokens alphabetically by the second character of the scope value.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['token_id', 'scope']:
  [1086, 'admin']
  [1387, 'admin']
  [1129, 'read:users']
  [1215, 'read:analytics']
  [1301, 'read']
*/


-- Write your SQL solution below:

SELECT token_id, scope
FROM api_tokens
ORDER BY SUBSTR(scope, 2, 1) ASC
