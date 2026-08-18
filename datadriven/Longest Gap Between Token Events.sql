-- ======================================================================
-- Longest Gap Between Token Events
-- ======================================================================
-- Difficulty : Medium
-- Company    : Yelp
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/longest_gap_between_token_events
-- ======================================================================

/*
The security team is reviewing API key rotation policy. Calculate the longest period in days between consecutive token issuances and the longest period between consecutive token expirations in api_tokens. Ignore null expiration dates. Return both maximum gap values.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['max_issue_gap_days', 'max_expire_gap_days']:
  [52, 82]
*/


-- Write your SQL solution below:

WITH issue_gaps AS (
    SELECT JULIANDAY(issued)
           - JULIANDAY(LAG(issued) OVER (ORDER BY issued)) AS gap
    FROM api_tokens
),
expire_gaps AS (
    SELECT JULIANDAY(expires)
           - JULIANDAY(LAG(expires) OVER (ORDER BY expires)) AS gap
    FROM api_tokens
    WHERE expires IS NOT NULL
)
SELECT (SELECT MAX(gap) FROM issue_gaps)  AS max_issue_gap_days,
       (SELECT MAX(gap) FROM expire_gaps) AS max_expire_gap_days
