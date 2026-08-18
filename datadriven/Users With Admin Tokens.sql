-- ======================================================================
-- Users With Admin Tokens
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/users_with_admin_tokens
-- ======================================================================

/*
Find every user who owns at least one API token whose scope contains the substring 'admin'. Return the user_id, username, email, token_id, and the token's scope. Sort by user_id ascending.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: api_tokens(token_id, owner_id, scope, status, issued, expires, last_used, requests)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - api_tokens ['token_id', 'owner_id', 'scope', 'status', 'issued', 'expires', 'last_used', 'requests']:
  [1043, 197, 'write', 'revoked', '2025-02-02', '2027-02-02', '2026-02-02', 47]
  [1086, 294, 'admin', 'expired', '2025-03-03', '2027-03-03', '2026-03-03', 94]
  [1129, 391, 'read:users', 'Active', '2025-04-04', '2027-04-04', '2026-04-04', 141]
  [1172, 488, 'write:orders', 'REVOKED', '2025-05-05', '2027-05-05', '2026-05-05', 188]
  [1215, 585, 'read:analytics', 'active', '2025-06-06', '2027-06-06', '2026-06-06', 235]

Expected output ['user_id', 'username', 'email', 'token_id', 'scope']:
  [100, 'alice', 'alice@example.com', 5300, 'admin']
  [100, 'alice', 'alice@example.com', 10005400, 'admin']
  [197, 'aaron42', 'aaron42@example.com', 3193, 'admin']
  [197, 'aaron42', 'aaron42@example.com', 10005351, 'admin']
  [294, 'amelia', 'amelia@example.com', 1086, 'admin']
*/


-- Write your SQL solution below:

SELECT
    u.user_id,
    u.username,
    u.email,
    t.token_id,
    t.scope
FROM users u
JOIN api_tokens t ON t.owner_id = u.user_id
WHERE t.scope LIKE '%admin%'
ORDER BY u.user_id ASC;
