-- ======================================================================
-- Who Comes Early
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/signups_jan_to_jul
-- ======================================================================

/*
We record each user's signup date and want to compare the year-opening intake from one year to the next. Count the users who signed up between January and July, earliest year first.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['signup_year', 'signup_count']:
  ['2023', 17]
  ['2024', 33]
  ['2025', 35]
  ['2026', 34]
*/


-- Write your SQL solution below:

SELECT
  strftime('%Y', signup_date) AS signup_year,
  COUNT(*) AS signup_count
FROM users
WHERE CAST(strftime('%m', signup_date) AS INTEGER) BETWEEN 1 AND 7
GROUP BY signup_year
ORDER BY signup_year
