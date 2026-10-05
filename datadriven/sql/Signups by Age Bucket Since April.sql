-- ======================================================================
-- Signups by Age Bucket Since April
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/signups_by_age_bucket_since_april
-- ======================================================================

/*
The marketing team is profiling the spring signup wave (April 1, 2026 onward) by age demographics. Show each age bucket alongside its signup count, largest groups first.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['age_bucket', 'user_count']:
  ['55-64', 7]
  ['25-34', 7]
  ['65+', 6]
  ['45-54', 5]
  ['35-44', 5]
*/


-- Write your SQL solution below:

SELECT age_bucket, COUNT(*) AS user_count
FROM users
WHERE signup_date >= '2026-04-01'
GROUP BY age_bucket
ORDER BY user_count DESC
