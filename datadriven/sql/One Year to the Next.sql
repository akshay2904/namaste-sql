-- ======================================================================
-- One Year to the Next
-- ======================================================================
-- Difficulty : Hard
-- Company    : Airbnb
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/yoy_signup_growth_rate
-- ======================================================================

/*
We track how many users sign up each year and want to see whether that number is climbing or falling. For each year, report the signup count alongside the percentage change from the prior year's total, rounded to the nearest whole percent.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['signup_year', 'signups', 'prev_year_signups', 'yoy_growth_pct']:
  ['2023', 25, None, None]
  ['2024', 58, 25, 132]
  ['2025', 59, 58, 2]
  ['2026', 58, 59, -2]
*/


-- Write your SQL solution below:

WITH yearly_signups AS (
  SELECT strftime('%Y', signup_date) AS signup_year,
         COUNT(DISTINCT user_id) AS signups
  FROM users
  GROUP BY signup_year
)
SELECT signup_year,
       signups,
       LAG(signups) OVER (ORDER BY signup_year) AS prev_year_signups,
       ROUND(
         CAST((signups - LAG(signups) OVER (ORDER BY signup_year)) AS REAL)
         / CAST(LAG(signups) OVER (ORDER BY signup_year) AS REAL)
         * 100
       ) AS yoy_growth_pct
FROM yearly_signups
ORDER BY signup_year
