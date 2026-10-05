-- ======================================================================
-- The Ones Who Clicked
-- ======================================================================
-- Difficulty : Hard
-- Company    : Microsoft
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/search_success_by_user_tenure
-- ======================================================================

/*
We're comparing search quality across signup cohorts for a shopping marketplace, grouping users by the calendar year they joined. For each cohort, return how many searches its users ran, how many of those ended in a clicked result, and the resulting success rate.

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

Expected output ['signup_cohort', 'total_searches', 'successful_searches', 'success_rate']:
  ['2024', 50, 0, 0]
  ['2025', 50, 48, 0.96]
  ['2026', 50, 46, 0.92]
*/


-- Write your SQL solution below:

WITH cohort AS (
    SELECT u.user_id, strftime('%Y', u.signup_date) AS signup_cohort
    FROM users u
)
SELECT
    c.signup_cohort,
    COUNT(*) AS total_searches,
    SUM(CASE WHEN sq.clicked_result IS NOT NULL THEN 1 ELSE 0 END) AS successful_searches,
    CAST(SUM(CASE WHEN sq.clicked_result IS NOT NULL THEN 1 ELSE 0 END) AS REAL) / COUNT(*) AS success_rate
FROM search_queries sq
JOIN cohort c ON sq.user_id = c.user_id
GROUP BY c.signup_cohort
ORDER BY c.signup_cohort
