-- ======================================================================
-- Monthly Signup Counts
-- ======================================================================
-- Difficulty : Easy
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_signup_counts
-- ======================================================================

/*
A downstream forecasting model requires monthly signup counts as floating-point values, but the dashboard also needs the raw integer. For each month (YYYY-MM format), show the signup count in both forms.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['month', 'signup_count', 'signup_count_float']:
  ['2023-01', 8, 8]
  ['2023-05', 9, 9]
  ['2023-09', 8, 8]
  ['2024-04', 17, 17]
  ['2025-11', 16, 16]
*/


-- Write your SQL solution below:

SELECT STRFTIME('%Y-%m', signup_date) AS month,
    COUNT(*) AS signup_count,
    CAST(COUNT(*) AS DOUBLE) AS signup_count_float
FROM users
GROUP BY STRFTIME('%Y-%m', signup_date)
ORDER BY month
