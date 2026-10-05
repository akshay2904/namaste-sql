-- ======================================================================
-- Most Popular Signup Day
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_popular_signup_day
-- ======================================================================

/*
The growth team is scheduling promotional pushes and wants to amplify the days that already get the most organic signups. Show each day of the week alongside its signup count, sorted from most to fewest.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['signup_day', 'signup_count']:
  ['Monday', 31]
  ['Thursday', 30]
  ['Saturday', 29]
  ['Sunday', 28]
  ['Tuesday', 27]
*/


-- Write your SQL solution below:

SELECT CASE
        WHEN CAST(STRFTIME('%w', signup_date) AS INTEGER) = 0 THEN 'Sunday'
        WHEN CAST(STRFTIME('%w', signup_date) AS INTEGER) = 1 THEN 'Monday'
        WHEN CAST(STRFTIME('%w', signup_date) AS INTEGER) = 2 THEN 'Tuesday'
        WHEN CAST(STRFTIME('%w', signup_date) AS INTEGER) = 3 THEN 'Wednesday'
        WHEN CAST(STRFTIME('%w', signup_date) AS INTEGER) = 4 THEN 'Thursday'
        WHEN CAST(STRFTIME('%w', signup_date) AS INTEGER) = 5 THEN 'Friday'
        WHEN CAST(STRFTIME('%w', signup_date) AS INTEGER) = 6 THEN 'Saturday'
    END AS signup_day,
    COUNT(*) AS signup_count
FROM users
WHERE signup_date IS NOT NULL
GROUP BY CAST(STRFTIME('%w', signup_date) AS INTEGER)
ORDER BY signup_count DESC, CAST(STRFTIME('%w', signup_date) AS INTEGER) ASC
