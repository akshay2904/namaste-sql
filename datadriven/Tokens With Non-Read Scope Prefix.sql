-- ======================================================================
-- Tokens With Non-Read Scope Prefix
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/tokens_with_non_read_scope_prefix
-- ======================================================================

/*
A security audit needs to verify that all API tokens have a scope starting with 'read'. Count the number of unique owners whose scope does not begin with 'read'.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['non_read_owner_count']:
  [50]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS non_read_owner_count
FROM (
  SELECT owner_id
  FROM api_tokens
  GROUP BY owner_id
  HAVING SUM(CASE WHEN scope LIKE 'read%' THEN 0 ELSE 1 END) > 0
) violators
