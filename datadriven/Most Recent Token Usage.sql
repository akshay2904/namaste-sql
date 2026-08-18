-- ======================================================================
-- Most Recent Token Usage
-- ======================================================================
-- Difficulty : Easy
-- Company    : OpenDoor
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_recent_token_usage
-- ======================================================================

/*
The security team is auditing API token activity. For each token owner, pull only the single most recently used record. Include all token fields (ID, owner, scope, status, issued date, expiration, last used date, request count) and a row indicator.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests', 'rn']:
  [5300, 100, 'admin', 'active', '2025-05-17', '2027-05-17', '2026-05-17', 4700, 1]
  [3193, 197, 'admin', 'revoked', '2025-04-24', '2027-04-24', '2026-04-24', 2397, 1]
  [3236, 294, 'read:users', 'expired', '2025-05-25', '2027-05-25', '2026-05-25', 2444, 1]
  [3279, 391, 'write:orders', 'Active', '2025-06-26', '2027-06-26', '2026-06-26', 2491, 1]
  [3322, 488, 'read:analytics', 'REVOKED', '2025-07-27', None, '2026-07-27', 2538, 1]
*/


-- Write your SQL solution below:

SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY owner_id ORDER BY last_used DESC, token_id DESC) AS rn
  FROM api_tokens
)
WHERE rn = 1
ORDER BY owner_id
