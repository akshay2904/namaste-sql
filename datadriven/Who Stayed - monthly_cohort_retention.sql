-- ======================================================================
-- Who Stayed
-- ======================================================================
-- Difficulty : Medium
-- Company    : iHeartMedia
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_cohort_retention
-- ======================================================================

/*
Group users into signup cohorts by the month they registered, and track how each cohort holds up over the following months. For every month from signup onward, report the share of the cohort who had at least one session that month, labeled by how many months after signup it falls.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['cohort_month', 'months_since_signup', 'retention_rate']:
  ['2024-01', 7, 0.25]
  ['2024-01', 24, 0.125]
  ['2024-01', 25, 0.25]
  ['2024-01', 27, 0.125]
  ['2024-01', 31, 0.125]
*/


-- Write your SQL solution below:

WITH cohorts AS (
  SELECT user_id, substr(signup_date, 1, 7) AS cohort_month
  FROM users
),
cohort_sizes AS (
  SELECT cohort_month, COUNT(*) AS cohort_size
  FROM cohorts
  GROUP BY cohort_month
),
activity AS (
  SELECT DISTINCT user_id, substr(session_start, 1, 7) AS active_month
  FROM user_sessions
),
active_cohorts AS (
  SELECT
    c.cohort_month,
    a.user_id,
    (CAST(substr(a.active_month, 1, 4) AS INTEGER) - CAST(substr(c.cohort_month, 1, 4) AS INTEGER)) * 12
      + (CAST(substr(a.active_month, 6, 2) AS INTEGER) - CAST(substr(c.cohort_month, 6, 2) AS INTEGER)) AS months_since_signup
  FROM cohorts c
  JOIN activity a ON c.user_id = a.user_id
)
SELECT
  ac.cohort_month,
  ac.months_since_signup,
  CAST(COUNT(DISTINCT ac.user_id) AS DOUBLE) / cs.cohort_size AS retention_rate
FROM active_cohorts ac
JOIN cohort_sizes cs ON ac.cohort_month = cs.cohort_month
WHERE ac.months_since_signup >= 0
GROUP BY ac.cohort_month, ac.months_since_signup
ORDER BY ac.cohort_month, ac.months_since_signup
