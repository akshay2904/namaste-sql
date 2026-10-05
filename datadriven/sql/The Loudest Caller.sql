-- ======================================================================
-- The Loudest Caller
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_api_token_scopes
-- ======================================================================

/*
Find the different scopes held by the account with the highest total request volume. If several accounts are tied at the top, include the scopes from all of them.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['scope']:
  ['admin']
  ['write']
*/


-- Write your SQL solution below:

SELECT DISTINCT scope
FROM api_tokens
WHERE owner_id IN (
    SELECT owner_id
    FROM api_tokens
    GROUP BY owner_id
    HAVING SUM(requests) = (
        SELECT MAX(total_req)
        FROM (
            SELECT SUM(requests) AS total_req
            FROM api_tokens
            GROUP BY owner_id
        )
    )
)
ORDER BY scope
