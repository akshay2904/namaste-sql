-- ======================================================================
-- API Token Churn Rate
-- ======================================================================
-- Difficulty : Medium
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/api_token_churn_rate
-- ======================================================================

/*
The developer experience team is measuring token churn for the platform health dashboard. Compute the fraction of all issued API tokens whose expiration date has already passed, treating tokens with no expiration as still active. Express the result as a decimal ratio, not a percentage.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['churn_rate']:
  [0.42]
*/


-- Write your SQL solution below:

SELECT CAST(SUM(CASE WHEN expires IS NOT NULL AND date(expires) < date('now') THEN 1 ELSE 0 END) AS REAL) / COUNT(*) AS churn_rate
FROM api_tokens
