-- ======================================================================
-- Poles Apart
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/extreme_api_token_usage
-- ======================================================================

/*
We audit API tokens at both ends of the usage spectrum: the busiest and the quietest, counting only tokens that have been used at least once. Return those tokens with their request counts, busiest first.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['token_id', 'requests']:
  [5300, 4700]
  [10005400, 4700]
  [1043, 47]
  [10005301, 47]
*/


-- Write your SQL solution below:

SELECT token_id, requests FROM api_tokens WHERE last_used IS NOT NULL AND (requests = (SELECT MAX(requests) FROM api_tokens WHERE last_used IS NOT NULL) OR requests = (SELECT MIN(requests) FROM api_tokens WHERE last_used IS NOT NULL)) ORDER BY requests DESC
