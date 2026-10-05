-- ======================================================================
-- Still Breathing
-- ======================================================================
-- Difficulty : Medium
-- Company    : LinkedIn
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/active_tokens_on_target_date
-- ======================================================================

/*
The security team is auditing which owners held a live API token on November 1 of 2026, and each qualifying owner should appear once. Different services write the status column inconsistently, so treat a token as enabled only when its status reads exactly as the lowercase word 'active'. A live token also had to be issued before that date and not yet expired, with a missing expiration date treated as still valid.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['owner_id']:
  [100]
  [585]
  [1070]
  [1555]
  [2040]
*/


-- Write your SQL solution below:

SELECT DISTINCT owner_id
FROM api_tokens
WHERE status = 'active'
  AND issued < '2026-11-01'
  AND (expires IS NULL OR expires > '2026-11-01')
ORDER BY owner_id
