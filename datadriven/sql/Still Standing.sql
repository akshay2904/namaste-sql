-- ======================================================================
-- Still Standing
-- ======================================================================
-- Difficulty : Medium
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_active_api_tokens
-- ======================================================================

/*
We're auditing which API tokens are still carrying live traffic. Surface the 5 busiest tokens that haven't expired, where a token counts as unexpired if it has no expiration date set or its expiration is still in the future, and show each token with its issuance date.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['token_id', 'issued']:
  [5300, '2025-05-17']
  [5257, '2025-04-16']
  [5214, '2025-03-15']
  [5171, '2025-02-14']
  [5085, '2025-12-12']
*/


-- Write your SQL solution below:

SELECT token_id, issued
FROM api_tokens
WHERE expires IS NULL OR expires > date('now')
ORDER BY requests DESC
LIMIT 5
