-- ======================================================================
-- Unused Read Tokens
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unused_read_tokens
-- ======================================================================

/*
The security team is cleaning up unused tokens. Find all API tokens scoped to 'read' that have never been used (zero requests).

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [3408, 682, 'read', 'revoked', '2025-09-01', '2027-09-01', None, 0]
  [10005356, 682, 'read', 'revoked', '2022-08-01', '2022-08-01', None, 0]
*/


-- Write your SQL solution below:

SELECT *
FROM api_tokens
WHERE scope = 'read'
  AND requests = 0
