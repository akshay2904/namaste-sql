-- ======================================================================
-- Searches by Users With Email
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/searches_by_users_with_email
-- ======================================================================

/*
The search quality team is analyzing result effectiveness but only for identifiable users. Pull all search query details for users who have an email address on file, limited to queries that returned at least one result.

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']
  [2426, 585, '4k monitor', 102, None, '2026-07-07 06:06:00']
*/


-- Write your SQL solution below:

SELECT sq.query_id, sq.user_id, sq.search_term, sq.results_count, sq.clicked_result, sq.query_time
FROM search_queries sq
JOIN users u ON sq.user_id = u.user_id
WHERE u.email IS NOT NULL AND sq.results_count > 0
