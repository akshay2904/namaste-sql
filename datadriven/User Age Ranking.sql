-- ======================================================================
-- User Age Ranking
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/user_age_ranking
-- ======================================================================

/*
Assign each user a rank based on their age bucket in descending order (oldest bucket first). Show each user's ID and their assigned rank.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['user_id', 'rank']:
  [488, 1]
  [1167, 1]
  [391, 2]
  [294, 3]
  [197, 4]
*/


-- Write your SQL solution below:

SELECT user_id,
       DENSE_RANK() OVER (ORDER BY age_bucket DESC) AS rank
FROM users
ORDER BY rank, user_id;
