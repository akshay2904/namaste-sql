-- ======================================================================
-- Keep Most Recent Record
-- ======================================================================
-- Difficulty : Medium
-- Company    : Capital One
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/keep_most_recent_record
-- ======================================================================

/*
The users table has duplicate entries from overlapping import jobs, causing downstream fan-outs. Write a query that deduplicates by keeping only the most recently updated record for each user.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['user_id', 'username', 'email', 'signup_date']:
  [100, 'alice', 'alice@example.com', '2025-02-02']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03']
  [294, 'amelia', 'amelia@example.com', '2024-04-04']
  [391, 'arjun', 'arjun@example.com', '2025-05-05']
  [488, 'ava99', 'ava99@example.com', '2026-06-06']
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT
    user_id,
    username,
    email,
    signup_date,
    ROW_NUMBER() OVER (
      PARTITION BY user_id
      ORDER BY signup_date DESC
    ) AS rn
  FROM users
)
SELECT user_id, username, email, signup_date
FROM ranked
WHERE rn = 1;
