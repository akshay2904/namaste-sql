-- ======================================================================
-- 7-Day Token Retention
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/7_day_token_retention
-- ======================================================================

/*
The developer platform team wants a 7-day token retention curve. A token counts as ACTIVE-WITH-TRAFFIC when its status is 'active' (compare it case-insensitively, since the data mixes 'active' and 'Active') and its requests value is greater than 0. A token with no expiration date is treated as still valid. For each issuance date, report two numbers side by side: how many distinct owners had an active-with-traffic token issued that day (active_day0), and how many of those same owners still held an active-with-traffic token that was valid as of 7 days after that date, i.e. issued on or before issued+7 and not expired before issued+7 (active_day7). Order by the issuance date and return only the first 7 dates.

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['the_date', 'active_day0', 'active_day7']:
  ['2024-01-14', 1, 0]
  ['2024-01-18', 1, 0]
  ['2024-02-11', 1, 0]
  ['2024-02-15', 1, 0]
  ['2024-03-04', 1, 0]
*/


-- Write your SQL solution below:

WITH active_tokens AS (
  SELECT token_id, owner_id, issued, expires
  FROM api_tokens
  WHERE LOWER(status) = 'active' AND requests > 0
)
SELECT a.issued AS the_date,
       COUNT(DISTINCT a.owner_id) AS active_day0,
       COUNT(DISTINCT b.owner_id) AS active_day7
FROM active_tokens a
LEFT JOIN active_tokens b
  ON b.owner_id = a.owner_id
 AND DATE(b.issued) <= DATE(a.issued, '+7 days')
 AND (b.expires IS NULL OR DATE(b.expires) >= DATE(a.issued, '+7 days'))
GROUP BY a.issued
ORDER BY a.issued
LIMIT 7;
