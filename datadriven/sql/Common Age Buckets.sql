-- ======================================================================
-- Common Age Buckets
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/common_age_buckets
-- ======================================================================

/*
The growth team is profiling the user base by age demographics. Which age buckets have more than one user? Show each qualifying bucket and its user count, sorted from largest to smallest.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['age_bucket', 'user_count']:
  ['65+', 29]
  ['55-64', 29]
  ['35-44', 29]
  ['45-54', 28]
  ['18-24', 28]
*/


-- Write your SQL solution below:

SELECT age_bucket, COUNT(*) AS user_count
FROM users
GROUP BY age_bucket
HAVING COUNT(*) > 1
ORDER BY user_count DESC
