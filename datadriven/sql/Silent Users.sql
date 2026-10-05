-- ======================================================================
-- Silent Users
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/silent_users
-- ======================================================================

/*
The search relevance team is running an engagement audit and needs to identify users who have never issued a search query on the platform. Pull every user account ,  even those with no search activity on record ,  and surface only the accounts that have no associated searches. For each such user, show their username and the date they signed up. Present from the most recently joined to the earliest.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['username', 'signup_date']:
  ['tessa', '2026-10-28']
  ['sara', '2026-10-24']
  ['val', '2026-10-24']
  ['niko', '2026-10-20']
  ['josephine', '2026-10-16']
*/


-- Write your SQL solution below:

SELECT u.username, u.signup_date
FROM users u
LEFT
JOIN search_queries sq ON u.user_id = sq.user_id
WHERE sq.query_id IS NULL
ORDER BY u.signup_date DESC
