-- ======================================================================
-- Keys That Never Die
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/token_churn_rate
-- ======================================================================

/*
The security team is auditing API token hygiene. A token with no expiration date (expires IS NULL) lives forever and is a standing risk. What percentage of all API tokens are these never-expiring tokens? Return a single number rounded to 2 decimal places as perpetual_pct.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['perpetual_pct']:
  [16]
*/


-- Write your SQL solution below:

SELECT ROUND(CAST(SUM(CASE WHEN expires IS NULL THEN 1 ELSE 0 END) AS REAL) * 100.0 / COUNT(*), 2) AS perpetual_pct FROM api_tokens
