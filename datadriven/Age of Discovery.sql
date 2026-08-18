-- ======================================================================
-- Age of Discovery
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/upvote_percentage_by_age_cohort
-- ======================================================================

/*
The search team wants to see how well different age cohorts find what they're after on our shopping platform. For every cohort with an age band on file, show the total searches, how many of those clicked through to a result, and the success rate as a decimal, listed alphabetically by cohort.

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

Expected output ['age_bucket', 'total_searches', 'successful_searches', 'success_rate']:
  ['18-24', 22, 10, 0.45454545454545453]
  ['25-34', 22, 14, 0.6363636363636364]
  ['35-44', 22, 14, 0.6363636363636364]
  ['55-64', 20, 14, 0.7]
  ['65+', 20, 14, 0.7]
*/


-- Write your SQL solution below:

SELECT
    u.age_bucket,
    COUNT(*) AS total_searches,
    SUM(CASE WHEN sq.clicked_result IS NOT NULL THEN 1 ELSE 0 END) AS successful_searches,
    CAST(SUM(CASE WHEN sq.clicked_result IS NOT NULL THEN 1 ELSE 0 END) AS REAL)
        / COUNT(*) AS success_rate
FROM search_queries sq
INNER JOIN users u ON sq.user_id = u.user_id
WHERE u.age_bucket IS NOT NULL
GROUP BY u.age_bucket
ORDER BY u.age_bucket;
