-- ======================================================================
-- The Token Census
-- ======================================================================
-- Difficulty : Easy
-- Company    : Apple
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_token_census
-- ======================================================================

/*
The platform team needs a headcount of how many token owners issued at least one API token during 2026. Return a single count of unique owners.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['distinct_owners']:
  [10]
*/


-- Write your SQL solution below:

SELECT COUNT(DISTINCT owner_id) AS distinct_owners
FROM api_tokens
WHERE strftime('%Y', issued) = '2026'
